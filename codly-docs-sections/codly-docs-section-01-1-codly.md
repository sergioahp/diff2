## 1. Codly

Codly is a library that enhances the way you write code blocks in Typst. It provides a set of tools to help you manage your code blocks, highlights them, skip parts of them, and more. This manual will guide you through the different features of Codly, how to use them, and how to integrate them into your Typst projects.

> **Notification**
> If you find any issues with Codly, please report them on the GitHub repository: <https://github.com/Dherse/codly>.

### 1.1. Initialization

To start using Codly, you must first import it into your Typst project.

| Example code | Rendered output |
| :--- | :--- |
| 1 `#import "@preview/codly:1.3.1": *` | |
| 2 | |
| 3 `#show: codly-init` | |

As you can see, this does nothing but initialize codly. You can also import it with a specific version, as shown in the example above. For the latest version, always refer to the [Typst Universe page](https://typst.app/universe/packages/codly).

From this point on, any code block that is included in your Typst project will be enhanced by Codly.

| Example code | Typst | Rendered output |
| :--- | :--- | :--- |
| 1 ``` | 1 Hello, world! |
| 2 Hello, world! | |
| 3 ``` | |

### 1.2. Enabling and disabling codly

By default Codly will be enabled after initialization. However, disabling codly can be done using the `codly-disable` function, the `enabled` argument of the `codly` function, or the `no-codly` and `yes-codly` functions. To enable Codly again, use the `codly-enable` function or by setting the `enabled` parameter again.

### 1.3. Short guide to this manual

Codly can take a lot of different argument to configure your code blocks. Some of these arguments can have pretty complex behaviour, so this manual is here to help you understand how to use them. Each argument is acompagnied by a card that gives you important information about its usage. The card contains the following information:

*   the type(s) of values accepted;
*   the default value that is pre-set;
*   whether the argument can take a contextual function: if it can, you can pass it a function that will be called within a typst `context` block to customize the value of the argument yourself¹;
*   whether the argument is automatically reset after the code block is rendered;
*   whether the argument is already released in the current version of Codly or will be released in the next version.

| </> Type | `bool` or `auto` |
| :--- | :--- |
| {*} Default value | `true` |
| Contextual function | ✓ yes |
| Automatically reset | ✓ yes |
| Already released in 1.3.1 | x no |

Additionally to the card, most arguments are accompanied by an example that shows how to use the argument in a code block. The example is followed by a rendered output of the code block, which shows how the argument affects the code block.

---
¹This is mostly intended for libraries that wish to extend Codly, or for users that wish to have dynamic control over argument values using their own logic.

***
