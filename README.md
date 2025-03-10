# Bachelor Electrical Engineering :zap:

> [!NOTE]
> I'm done with my bachelor degree, so this is going to be a quieter repository. Feel free to add changes (or if you want, forking it, although I encourage you to create your own one).

Hello Dweller of Github or StudentBox User or curious friends that I've sent the summary to.

This repository contains summaries and some lab reports written in Latex, Quarto and Typst. The majority of the summaries are written using [Quarto](https://quarto.org/) and has been extended with some Latex templates. The last summaries were written using [Typst](https://typst.app/home/).

> ***Why Quarto (& Typst) and not Office Word?***<br>
> I've found Latex to be really powerful for thesis and documentations and gives off a consistent style! Quarto solves the learning curve of Latex for me, by replacing the language by rMarkdown. 
> 
> Newer tools such as Typst have emerged, which I've used for the final semester summaries. It's a cool tool and I'm thinking about using it for my future masters degree. It has (almost) instant compilation and thus allows for live previewing it. It has an easier programmer approach, than the other tools.

<center>
  <img src="important.jpg" alt="Flowers" width="400">
</center>

## Lovely Contributors

The peeps below have helped me out a lot with writing the summaries and without them I probably wouldn't be able to write the majority of them!

|<img src="https://github.com/threaming.png" width="60px;"/><br /><a href="https://github.com/threaming">threaming</a>|<img src="https://github.com/manuelfanger.png" width="60px;"/><br /><a href="https://github.com/manuelfanger">manuelfanger</a>|
|:-------------------------------------------------------------------------------------------------------------------------:|:----------------------------------------------------------------------------------------------------------------------------:|

## Compiling it yourself using Quarto

> [!WARNING]
> This will not work with Typst based documents. For those either use the [typst-cli](https://github.com/typst/typst) or the version of it [typst.app](https://typst.app/).

If you want to compile the documents for yourself, in the following steps I will try to explain the installation process.

> If you found something horribly wrong or some critical changes, then either inform me or create a pull request. Keeping it correct is the way to go!

### Install Quarto

Quarto is the crux of this whole matter. It handles all the building and rendering of the documents. It has a mild learning curve though.

- Open up the [Getting Started](https://quarto.org/docs/get-started/)-Page of Quarto and download the respective installer.
- Install Quarto

### Install the TinyTex Distribution

The template is Latex based and therefore you'd need to install a Latex distribution, if you haven't already. I'm currently using TinyTex, which can be installed via Quarto.

- If you don't have a distribution installed, following installs TinyTex

```bash
quarto install tinytex --update-path
```

**Neat to know**: If you have a TexLive based distribution, Quarto **automatically** installs missing packages!

### Install Visual Studio Code

- [Download](https://code.visualstudio.com/) & install Visual Studio Code
- Install Extensions
  - [Quarto](https://marketplace.visualstudio.com/items?itemName=quarto.quarto)
  - [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
  - [R](https://marketplace.visualstudio.com/items?itemName=REditorSupport.r)


### Alternative: Install RStudio

RStudio is neat, as its integration is much better than VSCode's, but lacks the customization (or easy access to change the customizations).

- [Download](https://posit.co/products/open-source/rstudio/) & install RStudio instead of Visual Studio Code

### Open up a Summary

Open up any folder and open up the respective `main_*.qmd`-file and hit the render/compile button.

Good Luck!

## `cmbright`

When using the TinyTex-Distribution (which is just a smaller TexLive with less packages), the `cmbright` package doesn't work with specific configuration (I think it has something to do with the `multicol` package), giving out an auto expansion error.

What worked for me was to install following packages manually...

- `cm-super`
- `fontspec`
- `hfbright`


..., run `updmap` in the terminal and afterwards set the quarto-setting in the document.

```bash
tlmgr.bat install cm-super cmbright fontspec hfbright
updmap
```

It does give a nicer text body (using CM Bright Light) and feels nice to look at.
