import CoreGraphics
import Wrappers

enum DirectionalAlignment: Hashable {
  case vertical(VerticalAlignment)
  case horizontal(HorizontalAlignment)
}

struct DirectionalStackLayout<Content>: Layout {
  let alignment: DirectionalAlignment
  let spacing: CGFloat
  var children: [AnyLayout<Content>]

  init(
    alignment: DirectionalAlignment,
    spacing: CGFloat = 0,
    @LayoutBuilder children: () -> [AnyLayout<Content>]
  ) {
    self.alignment = alignment
    self.spacing = spacing
    self.children = children()
//    precondition(self.children.isEmpty == false)
  }

//  // FIXME: Remove this overload when `LayoutBuilder` is fully fixed.
//  init<T>(
//    alignment: DirectionalAlignment,
//    spacing: CGFloat = 0,
//    @LayoutBuilder children: () -> T
//  ) where T: Layout, T.Content == Content {
//    self.init(alignment: alignment, spacing: spacing) {
//      [children().wrapIntoAnyLayout()]
//    }
//  }

  func build(_ traits: inout LayoutTraits) {
    sanitizeSize(traits.proposedSize)

    // Make the axis the opposite of the directional alignment
    let axis: Axis
    switch alignment {
    case .horizontal:
      axis = .vertical
    case .vertical:
      axis = .horizontal
    }

    func flipAxis(_ axis: Axis) -> Axis {
      switch axis {
      case .horizontal:
        return .vertical
      case .vertical:
        return .horizontal
      }
    }

    // FIXME: Use property syntax when possible.
    var _unallocatedSpace = Clamp(
      wrappedValue: traits.proposedSize[axis],
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
      var proposedSize: ProposedSize
      switch axis {
      case .horizontal:
        proposedSize = ProposedSize(
          width: 0,
          height: traits.proposedSize[flipAxis(axis)]
        )
      case .vertical:
        proposedSize = ProposedSize(
          width: traits.proposedSize[flipAxis(axis)],
          height: 0
        )
      }

      var childTraits = LayoutTraits(proposedSize: CGSize(proposedSize))
      children[index].build(&childTraits)
      // Cache the result for `0` on the main axis.
      caches[index][.zero] = DimensionsCache.Value(
        proposedSize: proposedSize,
        dimensions: childTraits.dimensions
      )

      // Propose `.infinity` on the main axis to the child.
      proposedSize[axis] = .infinity
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
        let proposedSize: ProposedSize
        switch axis {
        case .horizontal:
          proposedSize = ProposedSize(
            width: unallocatedSpace / CGFloat(children.count - offset),
            height: traits.proposedSize[flipAxis(axis)]
          )
        case .vertical:
          proposedSize = ProposedSize(
            width: traits.proposedSize[flipAxis(axis)],
            height: unallocatedSpace / CGFloat(children.count - offset)
          )
        }

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
    var length: CGFloat = 0
    var upperBound: CGFloat = 0
    var lowerBound: CGFloat = 0

    for index in children.indices {
      var childTraits = traits[index]
      let size = CGSize(childTraits.dimensions)

      // Position child on main axis.
      childTraits.origin[axis] = length
      // Move the main axis offset.
      length += size[axis]
      if children.indices.contains(index + 1) {
        length += spacing
      }

      // Align everything at 0.
      let minBound: CGFloat
      switch alignment {
      case .horizontal(let alignment):
        minBound = -childTraits.dimensions[alignment]
      case .vertical(let alignment):
        minBound = -childTraits.dimensions[alignment]
      }
      let maxBound = minBound + size[flipAxis(axis)]

      // Remember current orthogonal value.
      childTraits.origin[flipAxis(axis)] = minBound

      // Offset `yTop` if needed.
      let currentUpperBound = min(0, minBound)
      if upperBound > currentUpperBound {
        upperBound = currentUpperBound
      }
      // Offset `yBottom` if needed.
      let currentLowerBound = max(0, maxBound)
      if lowerBound < currentLowerBound {
        lowerBound = currentLowerBound
      }

      // Save the trait.
      traits[index] = childTraits
    }
    precondition(upperBound <= 0 && lowerBound >= 0)

    // Normalize y coordinates for all children
    let yOffset = abs(upperBound)
    for index in children.indices {
      traits[index].origin[flipAxis(axis)] += yOffset
    }

    // Compute the final orthogonal length.
    let finalOrthogonalLength = abs(upperBound - lowerBound)

    // Respect all sizes from children and compute own size so that every
    // child fits within own rect.
    let size: CGSize
    switch axis {
    case .horizontal:
      size = CGSize(width: length, height: finalOrthogonalLength)
    case .vertical:
      size = CGSize(width: finalOrthogonalLength, height: length)
    }
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

    var horizontalAlignmentSet: Set<HorizontalAlignment>
      = [.leading, .center, .trailing]
    var verticalAlignmentSet: Set<VerticalAlignment>
      = [.top, .center, .bottom, .firstTextBaseline, .lastTextBaseline]

    // Override current and basic alignments with the default value.
    switch alignment {
    case .horizontal(let alignment):
      horizontalAlignmentSet = horizontalAlignmentSet.union([alignment])
    case .vertical(let alignment):
      verticalAlignmentSet = verticalAlignmentSet.union([alignment])
    }

    horizontalAlignmentSet.forEach { guide in
      dimensions.alignments[guide] = .none
    }

    verticalAlignmentSet.forEach { guide in
      dimensions.alignments[guide] = .none
    }

    traits.dimensions = dimensions
  }

  mutating func layout(
    in rect: CGRect,
    using traits: inout LayoutTraits
  ) {
    precondition(rect.size == CGSize(traits.dimensions))

    for index in children.indices {
      let childRect = traits[index].rect(at: rect.origin)
      // FIXME: Temporarily disabled due to a rounding issue.
//      precondition(rect.contains(childRect))
      children[index].layout(in: childRect, using: &traits[index])
    }
  }
}
