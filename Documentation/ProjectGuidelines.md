# Project Guidelines

* some bullet points are highly inspired by `stdlib`
* 2 spaces instead of a single tab
* line limit is at 80 characters
* wrap and indent correctly (fight Xcode)
* debugger can't walk sideways, write code so that you can put a breakpoint anywhere
* 
  ```swift
  // Wrong
  if condition { foo() } else { bar() }

  // Correct
  if condition {
    foo()
  } else {
    bar()
  }
  ```

* please avoid ternary operator
* please avoid `$0` for clarity and readability of API's (exceptions due to compiler bugs are permitted)

TBD.


