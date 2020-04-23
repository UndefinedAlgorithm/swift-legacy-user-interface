import CoreGraphics
import Wrappers

public struct HStackLayout<Content>: Layout {
  let alignment: VerticalAlignment
  let spacing: CGFloat
  var children: [AnyLayout<Content>]

  public init(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat = 0,
    @LayoutBuilder children: () -> [AnyLayout<Content>]
  ) {
    self.alignment = alignment
    self.spacing = spacing
    self.children = children()
    precondition(self.children.isEmpty == false)
  }

  // FIXME: Remove this overload when `LayoutBuilder` is fully fixed.
  public init<T>(
    alignment: VerticalAlignment = .center,
    spacing: CGFloat = 0,
    @LayoutBuilder children: () -> T
  ) where T: Layout, T.Content == Content {
    self.init(alignment: alignment, spacing: spacing) {
      [children().wrapIntoAnyLayout()]
    }
  }

  public func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    let axis = Axis.horizontal

    // FIXME: Use property syntax when possible.
    var _unallocatedSpace = Clamp(
      wrappedValue: traits.proposedSize.width,
      range: 0 ... .infinity
    )
    var unallocatedSpace: CGFloat {
      get {
        _unallocatedSpace.wrappedValue
      }
      set {
        _unallocatedSpace.wrappedValue = newValue
      }
    }

    // Take all the width required for the internal spacing.
    unallocatedSpace -= CGFloat(children.count - 1) * spacing

    var caches = Array(
      repeating: DimensionsCache(axis: axis),
      count: children.count
    )

    // Fill the caches with dimensions for `0` and `.infinity` on the
    // main axis.
    for index in children.indices {
      // Propose `0` on the main axis to the child.
      var proposedSize = ProposedSize(
        width: 0,
        height: traits.proposedSize.height
      )
      var childTraits = LayoutTraits(proposedSize: CGSize(proposedSize))
      children[index].build(&childTraits)
      // Cache the result for `0` on the main axis.
      caches[index][.zero] = DimensionsCache.Value(
        proposedSize: proposedSize,
        dimensions: childTraits.dimensions
      )

      // Propose `.infinity` on the main axis to the child.
      proposedSize.width = .infinity
      childTraits = LayoutTraits(proposedSize: CGSize(proposedSize))
      children[index].build(&childTraits)
      // Cache the result for `.infinity` on the main axis.
      caches[index][.infinity] = DimensionsCache.Value(
        proposedSize: proposedSize,
        dimensions: childTraits.dimensions
      )
    }

    // Compute flexibility levels for all children based on the proposed
    // `0` and `infinity` values.
    caches
      .enumerated()
      .map { value in
        FlexibilityIndex(
          flexibilityLevel: value.element.flexibilityLevel,
          index: value.offset
        )
      }
      // Sort them in a way that least flexible children come first but
      // children with same level are sorted by their index in `children`
      // collection.
      .sorted { lhs, rhs in
        (rhs.flexibilityLevel, lhs.index) < (lhs.flexibilityLevel, rhs.index)
      }
      // Compute the final traits for all children.
      .enumerated()
      .forEach { (offset, flexibilityIndex) in
        // Propose the remaining space to the child.
        let proposedSize = ProposedSize(
          width: unallocatedSpace / CGFloat(children.count - offset),
          height: traits.proposedSize.height
        )
        var childTraits = LayoutTraits(proposedSize: CGSize(proposedSize))
        children[flexibilityIndex.index].build(&childTraits)
        // Cache the result.
        caches[flexibilityIndex.index][.any] = DimensionsCache.Value(
          proposedSize: proposedSize,
          dimensions: childTraits.dimensions
        )

        // Get child's minimum space and deduct it from `unallocatedSpace`.
        unallocatedSpace -= space(
          in: CGSize(caches[flexibilityIndex.index][.any].dimensions),
          onAxis: axis
        )

        // Save the child traits.
        traits[flexibilityIndex.index] = childTraits
      }

    // At this point we should have dimensions for all children.
    var (width, yTop, yBottom): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)

    for index in children.indices {
      var childTraits = traits[index]
      let size = CGSize(childTraits.dimensions)

      // Position child at current x.
      childTraits.origin.x = width
      // Move the x offset.
      width += size.width
      if children.indices.contains(index + 1) {
        width += spacing
      }

      // Align everything at 0.
      let yMin = -childTraits.dimensions[alignment]
      let yMax = yMin + size.height

      // Remember current y value.
      childTraits.origin.y = yMin

      // Offset `yTop` if needed.
      let currentYTop = min(0, yMin)
      if yTop > currentYTop {
        yTop = currentYTop
      }
      // Offset `yBottom` if needed.
      let currentYBottom = max(0, yMax)
      if yBottom < currentYBottom {
        yBottom = currentYBottom
      }

      // Save the trait.
      traits[index] = childTraits
    }
    precondition(yTop <= 0 && yBottom >= 0)

    // Normalize y coordinates for all children
    let yOffset = abs(yTop)
    for index in children.indices {
      traits[index].origin.y += yOffset
    }

    // Compute the final height.
    let height = abs(yTop - yBottom)

    // Respect all sizes from children and compute own size so that every
    // child fits within own rect.
    let size = CGSize(width: width, height: height)
    sanitizeSize(size)

    // Generate own dimensions.
    var dimensions = ViewDimensions(size: size)

    // Translate all alignments from all children.
    children
      .indices
      // Get a set of all explicit keys set by all children.
      .reduce(Set<AlignmentKey>()) { set, index in
        set.union(traits[index].dimensions.alignments.keys)
      }
      .forEach { key in
        // Compute explicit alignment values.
        var count = 0
        var value: CGFloat = 0
        for index in children.indices {
          let trait = traits[index]

          if let explicitValue = trait.dimensions.alignments[key] {
            // Increment the count as this child has an explicit value set
            // for given alignment key.
            count += 1
            // Get the position offset for the correct axis.
            let offset: CGFloat
            if key.representsHorizontalAlignment {
              offset = trait.origin.x
            } else {
              offset = trait.origin.y
            }
            // Translate the explicit alignment value based on where the child
            // is positioned.
            value += offset + explicitValue
          }
        }
        if count > 0 {
          // Save the average alignment value.
          dimensions.alignments[key] = value / CGFloat(count)
        }
      }

    // Override current and basic alignments with the default value.
    Set<VerticalAlignment>
      .init([.top, .center, .bottom, .firstTextBaseline, .lastTextBaseline])
      .union([alignment])
      .forEach { guide in
        dimensions.alignments[guide] = .none
      }
    Set<HorizontalAlignment>
      .init([.leading, .center, .trailing])
      .forEach { guide in
        dimensions.alignments[guide] = .none
      }

    traits.dimensions = dimensions
  }

  public mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))

    for index in children.indices {
      let childRect = traits[index].rect(at: rect.origin)
      precondition(rect.contains(childRect))
      children[index].layout(in: childRect, using: &traits[index])
    }
  }
}
