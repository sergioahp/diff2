## 4. Getting nice icons

This is a short, non-exhaustive guide on how to get nicer icons for the languages of your code blocks. In the documentation, codly makes use of tabler-icons to display the language icons. But a more general approach is the following:

1.  Chose a font that contains icons, such as:
    *   [Tabler Icons](https://tabler-icons.io/)
    *   [Font Awesome](https://fontawesome.com/)
    *   [Material Icons](https://material.io/resources/icons)
    *   Look on [Google Fonts](https://fonts.google.com/icons) for more options
2.  Download the font and put it in your project (if using the CLI, you need to set the `--font` argument)
3.  Using your font selector, select the icon you wish to use
    *   For example, the language icon in Tabler Icons is `\u{ebbe}` (the unicode value of the icon, which you can find in the documentation of the font)
    *   Use the `text` function to display the icon in your document by setting the font, size, and the unicode value of the icon:
    ```typst
    text(font: "tabler-icons" Font name, size: 1em, "\u{ebbe UTF-8 icon code}")
    ```
4.  You can store it the `languages` argument of the `codly` function to use it for all code blocks in your document:

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#let icon = text(font: "tabler-icons", size: 1em, "\u{ebbe}")` | | 1 Hello, world! A Text |
| 2 `#codly(languages: (text: (icon: icon, name: "Text")))` | | |
| 3 ``text | | |
| 4 `Hello, world!` | | |
| 5 ``` | | |

5.  Congrats, you now have fancy icons!
6.
7.  But you can notice that the baseline of the icon is wrong, i find that this is generally the case with tabler, you can set the baseline to `0.1em` in the icon to fix it:

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#let icon = text(font: "tabler-icons", size: 1em, "\u{ebbe}", baseline: 0.1em)` | | 1 Hello, world! A Text |
| 2 `#codly(languages: (text: (icon: icon, name: "Text")))` | | |
| 3 ``text | | |
| 4 `Hello, world!` | | |
| 5 ``` | | |

### 4.1. Typst language icon (`typst-icon`)

Additionally, codly ships with language definitions for the Typst language. You can use the `typst-icon` function to get the Typst icon for your code blocks. This function takes no arguments and returns the proper settings for codly to use the Typst icon.

> **Info**
> You can use the `...` spread operator to spread it into your own `languages` dictionary.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 `#codly(languages: typst-icon)` | | 1 = Here's a title Typst |
| 2 ``typ | | 2 Hello, world! |
| 3 `= Here's a title` | | |
| 4 `Hello, world!` | | |
| 5 ``` | | |

***
