# Unix tutorial – Variables, Loops, and Shell Scripts
Hannes Svardal

*Acknowledgments:* This tutorial is inspired by several internet resources and specifically by
the tutorials used for the Evolution and Genomics workshops in Cesky Krumlov https://evomics.org/

> **Note:**
> Some of this material is based on the UnixBasics tutorial. If you are not familiar with Unix, 
> I recommend you to start with the [UnixBasics](UnixBasics.md) tutorial.     

### Shell variables

You can think of a shell variable as a string (say, 'word'), 
such as a directory name, filename, number, sentence etc.
A variable is initialised using the name you designate for it. The name can be whatever you want (e.g. 'direc', 'superman', 'x', 'file' etc.) as long as it is a single word without spaces or special characters. The variable is then addressed using `$` in front of its name. For example, if the variable is named 'direc' it is referenced using `$direc`.

You can assign values to variables using `=`, for example if you want to assign the value 'hello' to the variable `myvar`,
you would execute in a terminal or shell script

        myvar='hello'

This variable assignment will be remembered as long as your terminal is open. Lets illustrate this with
an example.

We can use the command `echo` to print something to the screen. This is used like

    echo 'hello'

which will print `hello` to the terminal.

We can also define a variable the content of which would be the word 'hello', 
`my_variable='hello'` and print the content of the variable in the screen with `echo $my_variable`

**Q** Assign the value 'hello' to the variable `myvar` and print the content of the variable to the screen.

<!--The contents of the variable can be changed within a loop automatically 
without having to do so yourself manually.-->

### Wildcards

The asterisk `*` is referred to as a 'wildcard' symbol in unix. It allows for matching of filenames, directories etc. that
have certain parts of their name in common.
For example, if the names of all the files you are interested in start with ‘result’ 
(e.g. `result.txt`, `result.tree`, `result.nexus`, `resultFile`, `result`) these will all be recognised using `result*`.
Alternatively, if all files of interest end with `.txt`, you can loop over all of them using `*.txt`. 

**Q** Create three empty files `result.txt`, `result.tree`, `resultFile` in your current directory and use ls to show 
the size of those, and only those, files.

  <details>
    <summary>Show me how to do this.</summary>
    
    touch result.txt result.tree resultFile
    ls -sh result*

  </details>

### The use quotation marks 'string' in bash   

Quotation marks are used in many programming languages to define a string. 
Bash is a bit different from many programming
languages such as Python, R, C etc. in two ways. 
First, things you type on the bash command line are treated as strings by default. This means that code like

    myvar=hello

would actually work just as well as `myvar='hello'` used above because bash automatically assumes that hello is a string.
(**Note**: In python or R hello would be treated as a variable name and not a string, and they would throw an error if
no such variable had been defined beforehand).

That being said, it is good practice to use quotation marks to define strings in bash, because otherwise problems can
arise with strings that contain characters with special meaning in `bash`. The most simple example is a string that
contains a space. If you want to define a variable that contains a space, you need to use quotation marks. For example

    myvar='hello world'

If you do not add the quotes, bash will interpret the command as two separate commands, separated by the space: 
`myvar=hello` and `world`. The second command `world` will throw an error because it is not a valid command. Try this!

**Q** Define a variable `myvar` that contains the string `hello world` without using quotation marks. 
What error do you get?

<details>
    <summary>Show me the answer!</summary>

    myvar=hello world

Output:

    bash: world: command not found

</details>

#### The difference between single and double quotes in bash

In bash, single quotes `'` and double quotes `"` are used to define strings. The difference between the two is that
single quotes will treat everything inside them as a string, including special characters, while double quotes will
interpret some special characters as commands. 

As an example, try the following two commands:

    echo 'This is myvar: $myvar'
and

    echo "This is myvar: $myvar"

**Q** What is the difference in output between the two? Can you explain the difference?


### Repeating commands using loops

One of the really powerful things you can do in the terminal is the ability to repeat commands on multiple targets. 
For example creating many folders, moving multiple files into each folder, running commands and pipelines 
(sequences of commands) on multiple files/samples etc.
This can be accomplished by using the so called '**for loop**'. 
Both variables and wildcards are used in for loops to maximise their power.

A for loop has the following syntax in bash:

```
for 'variable' in 'list'
do
    'tasks to repeat for each item in list'
done
```

Each section is written on a separate line (e.g. after `do` hit enter) and instead of a prompt the terminal 
will display a `>` to designate you are in a multi-line command.
Alternatively, you can place a loop into a single line using the `;` symbol to separate the commands,
except for the line break after the `do` where there should not be a `;`


For example, we can use a for-loop to print the number 1 to 10 to screen by typing

    for num in {1..10}
    do
        echo $num
    done

This loop starts at 1, places the number in the variable num which can then be accessed inside the loop through $num.

**Q** Write the same loop as above in one line

<details>
    <summary>Show me the answer!</summary>

    for num in {1..10}; do echo $num; done;

    # Note that there is no semi-colon after ‘do’

</details>

**Q** Use a loop to create 3 directories with the names `run1`, `run2` and `run3`

<details>
    <summary>Show me the answer!</summary>

    for num in {1..3}; do mkdir "run"$num; done;

We place `"run"` before the variable to tell the system we want this string to be placed before the variable as part of 
the directory name. If we wanted it placed after (e.g. create `1run` etc.) we could use `$num"run"`


</details>


### Output redirection
You already learned in the  [UnixBasics](UnixBasics.md) tutorial  how to redirect the output of a command to a file 
using the redirection symbol `>`. For example, you can redirect the output of the `ls` command to a file by typing

    ls > some_file.txt

This will create a new file called `some_file.txt` and write the output of the `ls` command to it. 

**Q** Check the contents of the file `some_file.txt`

<details>
    <summary>Show me the answer!</summary>

You can use `cat` or `less` to check the content of the file. For example, 
you can type `cat some_file.txt` or `less some_file.txt`. The file should at least contain the names of the three
files created above, `result.txt`, `result.tree`, `resultFile`.

</details>

> **Important:**
> If the file already exists this will overwrite it with a new file.

Instead of always creating a new file (and overwriting it if it exists), 
you can also append to an existing file by using `>>`.
For example, you can append the output of the `ls -sh` command to the file `some_file.txt` by typing

    ls -sh >> some_file.txt


**Q** Append 'This is cool!' to `some_file.txt` that you created above. Check if the content has been changed using less.

<details>
    <summary>Show me the answer!</summary>

    echo 'This is cool!' >> some_file.txt

</details>

### Standard input, output and error

At this moment it is useful to introduce the concepts of standard input, output and error. Simply speaking, a bash 
command can receive input, and produce output and error messages.

#### Standard input (`stdin`)

This is the default place where commands listen for input. This might sound a bit cryptic to you, but
an easy example, remember the pipe `|` from the [UnixBasics](UnixBasics.md) tutorial? in the command

    grep 'LG12' Test_file_genomics_data.txt | head

 head takes the output of the grep command as input. The input is passed through the pipe `|` to the head command. 
The _stream_ where head listens for input is called the 'stdin' (standard input). Even if this still sounds a bit
crypitc, it is good to know that the 'stdin' is the name default place where commands/programs listen for information. This will come up in many other places in (bio)informatics.

#### Stdout and stderr

The `stream` where the output of a command is written is called `stdout` (standard out). Per default this is written to the screen of your terminal. So when you type `ls` or `echo hello` the output is written to `stdout` which per default is the screen, but when you used the `>` symbol above you redirected stdout to a file.

Programs can also produce error messages. These are written to a separate stream, the `stderr` (standard error). Per default, stderr is also written to the screen. This can be a bit confusing, because when you get something written to the screen, you might not know if it is an error message or a normal output. 

**Q** Produce a stderr output.


<details>
    <summary>Show me the answer!</summary>

For example, a 'stderr' can be produced by `less some_file_that_does_not_exist`

Output:

    some_file_that_does_not_exist: No such file or directory

</details>

It is **important** to note that you can redirect the `stdout` and `stderr` separately to files. A simple redirection
`>` will only redirect the `stdout` to a file. However, you have more options:


- `>` or `1>` will redirect your `stdout`,
- `2>` will redirect your `stderr`,
- `&>` will redirect both `stdout` and `stderr`.

**Q** Save the `stderr` you produced at the last question to a file.

<details>
    <summary>Show me the answer!</summary>

    less some_file_that_does_not_exist 2> error_msg.txt

</details>

> **Tip:**
> Instead of writing the `stdout`/`stderr` to the screen or to a file,
> you can also immediately delete it by redirecting the output to `/dev/null`, which is a stream that is immediately discarded.
>   `less some_file_that_does_not_exist 2> /dev/null`



### Writing bash scripts

Now what if we want to save some of the commands we wrote and run them automatically without
the need to type them all over again? 
For example, we might want to to apply the same commands later to new files. 
For that we can write a bash script.

A script is a **text file** that contains a suite of commands. When the script is executed or passed to an interpreter,
the commands are run one after
the other. A script needs to be interpreted by some kind of command interpreter. In the case of a bash script, 
the interpreter is _bash_, the same as the interpreter active in our terminal command line. However, one can also
write script to be interpreted by other programs such as other shells, R, python, etc.

At the start of a script, you can specify which interpreter should be used to interpret the script. 
This is done by adding a line at the start of the script that starts with `#!` followed by the path to the interpreter on your file system. For bash scripts, this line should be `#!/bin/bash` (Actually, a more general option is
`#!/usr/bin/env bash`, where the program `env` checks which `bash` is used by your system.). 



**Q** Start by creating an empty file and name it 'my_script.sh' then modify the content of the file, using _nano_.

<details>
    <summary>Show me how to create a file </summary>

    touch my_script.sh
    nano my_script.sh

</details>

**Q**  Add the for loop we used before that prints numbers 1 to 10 into your script.


You can write the following in your script:

    #!/bin/bash
    # a for-loop to print text and numbers from 0 to 10
    for num in {1..10}; do
    echo 'day '$num ':has been cool!'
    done

Using the `#` we can write notes in our script. They can be a small description of what the script is about.
Save and exit the script. Press `ctrl o` to save, `ENTER` to validate saving, `ctrl x` to exit




**Q** This script will print out a series from 0 to 10 with the text 'day 1 :has been cool!'. Let's execute the script
and see the output. To execute our script we can use the command:

    bash my_script.sh

This will print out in the screen the result of our for loop command.
Instead of printing it in the screen we could save the output in a file just by using the `>>` to redirect the output.

**Q** Modify your script by adding `>>` after the loop and specify a file `my_output.txt` where the output will be saved.

<details>
    <summary>Show me the answer!</summary>


    #!/bin/bash
    # a for-loop to print text and numbers from 0 to 10
    for num in {1..10}; do
    echo 'day '$num ':has been cool!'
    done >> my_output.txt
   

</details>

**Q** Run the script and check the output file that was created with `less my_output.txt`.

We can go a bit further and modify our script to make it interactive by allowing the script to get some of its
arguments directly in the command line. Just the same way as a command line command or program can get arguments or targets from the command line, a script can also get arguments from the command line. In the easiest case these are not named/flagged arguments, but just arguments that are named by the order they are given in the command line.

For example, if you run

    bash my_script.sh hello world

the strings `great` and `output` would be available in the script as varibles `${1}` and `${2}`, respectively.

**Q** Modify the script by replacing ':has been cool!' by `${1}` and my_output by `${2}`. Save the changes and exit the script. Then run the script with arguments, e.g., `bash my_script.sh great output2.txt`

<details>
    <summary>Show me how to do this!</summary>

Use nano to edit and save the script as follows:

    #!/bin/sh
    # a for-loop to print text and numbers from 0 to 10
    for num in {1..10}; do
    echo 'day '$num ${1}
    done >> ${2}.txt

</details>


Now the new output file 'output2.txt' should have the word 'great' instead of the initial ':has been cool!'.

**Q** Compare `my_output.txt` and `output2.txt`.

<details>
    <summary>Show me how to do this!</summary>

    cat my_output.txt
    cat output2.txt

or

    diff my_output.txt output2.txt

</details>


