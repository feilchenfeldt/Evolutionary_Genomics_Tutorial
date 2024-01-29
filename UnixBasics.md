# Unix tutorial – how to use the Terminal
Hannes Svardal

Acknowledgments:
This material is based on the Unix primer by Angelica Cuevas, Angela P. Fuentes-Pardo, Julia M.I. Barth
for the Population and Speciation Genomics Course in Cesky Krumlov 2022

## Introductory slides

Some introductory slides can be found here: [add link]

## Learning goals

- Navigate in a UNIX terminal environment
- Create, move, and delete directories
- Create, move, delete and edit files
- Use basic UNIX commands and know where to find help

## How to use this tutorial

- Open a unix terminal
  - On Windows
    - install the Windows subsystem for Linux (WSL)
    - Install Ubuntu 20.04 from the Windows Store
    - Press `Windows Key`, type *Ubuntu* and press `Enter`
  - On Linux:
    - Open a Terminal
  - MacOS:
    - Open the app *Terminal* or install and open the app *iTerm*
    - Make sure that your shell is set to *bash*
- Questions or tasks are indicated with **Q**
- Text `with gray background` usually indicates a command that you can type or copy to the terminal
- If you get stuck, check the answer-box:


Oh no, only if you get stuck!! First try to find the answer yourself!

## Why would we use the Terminal / shell in the first place?

*Scripting:* We can write down a sequence of commands to perform particular tasks or analyses;
when working with genomic data, a task usually takes minutes, sometimes hours or even days – it’s no fun to sit and wait in front of your computer this long just for a mouse-click to initiate the next task.

*Powerful Tools:* In UNIX, powerful tools are available that enable you to work through large amounts of files, data, and tasks quite quickly and in an automated (that is, programmatic) way.

*Easy remote access:* In most cases, it is not possible anymore to deal with genomic data on a desktop computer. You will usually run analyses on clusters at high performance computing facilities at your university, or – like in this course – on the Amazon cluster.

*GUI (Graphical User Interface) is not available* for many bioinformatics programs: Genomics is a fast evolving field and developing a GUI takes time and effort.

*Compatibility:* The terminal can (remotely) be accessed with computers running on different operating systems

## Basic syntax of shell commands

UNIX or shell commands have a basic structure of:
```
command -options target
```
The command comes first (such as cd or ls as we will see later) then any options (always proceeded by a – and also called flags) and then the target (such as the file to move or the directory to list). These commands are written on the prompt (terminal command line).

### Find your keys!

There are some keys that are used a lot in UNIX commands but can be difficult to find on some keyboards.

**Q** Open a text editor and type the following keys:

`~` tilde

`/` forward slash

`\` back slash or escape

`|` vertical bar or pipe

`#` hash or number or gate sign

`$` dollar sign

`*` asterisk

`’` single quote

`"` double quote

`  backtick

`ctrl c` The panic button: If you are running a process or 
program and it is stuck or doing something you don’t want it to
do: then hold the control key and press c. 
This will kill the current process and return you to your prompt.
If this does not work, close the terminal and open it again.

### Getting help

A UNIX cheat sheet like [this one here](https://files.fosswire.com/2007/08/fwunixref.pdf) might be helpful 
as a reference of some of the most common UNIX commands. <br>

Also, never forget that the internet is your best friend! Google your questions or use an AI chatbot. <br>

Most UNIX commands and many other programs have help pages accessed through: `command_name --help`, or `command_name -h`,
which also describe different ways to run a program.
Most programs also have a more exhaustive manual page accessed by typing `man PROGRAM_NAME`.

**Q** Access the `ls` help page and the `ls` manual page.

  <details>
    <summary>Show me how to do this.</summary>
    

Type ls --help to access the “list” help page.
Type man ls to access the “list” manual page.

Note that if you type ls -h you don’t get the help page for ls. That’s because -h is the option that print sizes of files in a human-readable format (like 1K, 234M, 2G etc) when combined with the -l option, like in ls -lh. Find the -h option when you access the ls help page with ls --help
    
    
  </details>





## Conda

In bioinformatics you will often need computer programs that are not part of your Unix default installation ...

### Installing conda

Download conda

```
wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh -b
```

Install miniconda

```
bash https://repo.anaconda.com/miniconda/Miniconda3-py38_23.11.0-2-Linux-x86_64.sh
```
You will be asked to review the license agreement. Press `Enter` to continue. Then `q` to quit the licence agreement. 
Then type `yes` to agree. You will need to type `yes` a few more times throughout the installation. Note: By "typing `yes`, I litterally mean typing the three letters y e s and then pressing `Enter`.

Once miniconda is installed, you need to *quit your terminal and open a new one* to have conda activated.







