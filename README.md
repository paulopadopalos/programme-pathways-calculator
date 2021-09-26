#  Combo Calculator
iOS app written using SwiftUI to determine the unique pathways through a degree programme.

## How it works
The app is divided into two main sections, **Modules** and **Programmes**.
- **Module**s represent a specific course unit which students may enrol on.
- **Programme**s represent a study objective for a student, which is acheived by studying one or more **Modules**s.
The job of a timetabler is to design a schedule for modules which allows for the various combinations of modules which students on different programmes may take. Therefore the amount of choice a programme offers is a measure of how easy or difficult it will be to schedule the modules.
When programmes are designed it is not always obvious how the choices offered to students will impact the timetable. This tool helps curriculum designers to measure the impact of the changes they are making.

##Some simple examples
- Allowing students to choose **4 modules from a list of 10** offers a total of **210 pathways**.
- Adding an extra choice, **4 modules from a list of 11** increases the number to **330 pathways**.
- Restructuring this as **2 modules from a list of 5** and **2 modules from a list of 6** decreases the number to **150 pathways**.
In other words, it is possible to offer more choice whilst reducing timetable complexity - but only through careful structuring of choices.

This app helps curriculum designers to visualise the impact of these changes. Each programme contains a number of choices, where students can pick either a specific number or a range of credits or modules, and the number of *unique* pathways offered by these choices are calculated.

The resulting pathways can be exported as a comma separated (CSV) file, so that timetabling staff can review the outputs and use it for their timetable planning and design.

### A note on spelling
This app uses the spelling *programme* rather than *program*. *Programme* is the British English spelling, and whilst less widely used it is chosen here to clarify between an academic *programme* studied at university, and a computer *program*.

### Dependencies
This app makes use of the [Swift Algorithms](https://github.com/apple/swift-algorithms) package for calculation of combinations and permutations.


