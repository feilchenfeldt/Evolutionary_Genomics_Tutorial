# Unix tutorial – Variables, Loops, and Shell Scripts
Hannes Svardal

*Acknowledgments:* This tutorial is inspired by several internet resources and specifically by
the tutorials used for the Evolution and Genomics workshops in Cesky Krumlov https://evomics.org/


### Shell variables

You can think of a shell variable as a string (say, 'word'), 
such as a directory name, filename, number, sentence etc.
A variable is initialised using the name you designate for it. The name can be whatever you want (e.g. 'direc', 'superman', 'x', 'file' etc.) as long as it is a single word without spaces or special characters. The variable is then addressed using `$` in front of its name. For example, if the variable is named 'direc' it is referenced using `$direc`.

You can assign values to variables using `=`, for example if you want to assign the value 'hello' to the variable `myvar`,
you would execute in a terminal or shell script

        myvar='hello'

This variable assignment will be remembered as long as your terminal is open.

The contents of the variable can be changed within a loop automatically without having to do so yourself manually.

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

### Repeating commands using loops

One of the really powerful things you can do in the terminal is the ability to repeat commands on multiple targets. 
For example creating many folders, moving multiple files into each folder, running commands and pipelines 
(sequences of commands) on multiple files/samples etc.
This can be accomplished by using the so called '**for loop**'. 
Both variables and wildcards are used in for loops to maximise their power.

A for-loop has the following syntax in bash:

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

For example, we can use the command `echo` to print something to the screen. This is used like

    echo 'hello'

which will print `hello` to the terminal.

We can also define a variable the content of which would be the word 'hello', 
`my_variable='hello'` and print the content of the variable in the screen with `echo $my_variable`

We can use a for-loop to print the number 1 to 10 to screen by typing

    for num in {1..10}
    do
        echo $num
    done

This loop starts at 1, places the number in the variable num which can then be accessed inside the loop through $num.

**Q** Write the same loop as above on one line

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
using the redirection symbol `>`. If the file already exists this will overwrite it with a new file.
Instead of writing to a new file, you can also append to an existing file by using `>>`

**Q** Append 'This is cool!' to the 'some_file.txt' that you created above. Check if the content has been changed using less.
Show me the answer!
echo 'This is cool!' >> some_file.txt
The default output that is written to the screen and that you redirect to a file is called the 'stdout' (standard out). 
In addition, there are two more default standard files: 'stdin' (standard input)
- the default place where commands listen for information,
- and 'stderr' (standard error) - used to write error messages.

Q Produce a stderr output.
Show me the answer!
For example, a 'stderr' can be produced by less some_file_that_does_not_exist
some_file_that_does_not_exist: No such file or directory
To save the 'stderr' message, you need to redirect the 'stderr' to a file by adressing it using a stream number.
1> will redirect your 'stdout',
2> will redirect your 'stderr',
&> will redirect 'stdout' and 'stderr'.

Q Save the stderr of the 'less' example above to a file.
Show me the answer!
less some_file_that_does_not_exist 2> error_msg.txt
Instead of writing the stdout/stderr to the screen or to a file,
you can also immediately delete it by redirecting the output to > /dev/null.
less some_file_that_does_not_exist 2> /dev/null


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

##In the beginning for 



Q Start by creating an empty file and name it 'my_script.sh' then modify the content of the file, using _nano_,
by including the for loop we used before:

Show me the answer!
touch my_script.sh
nano my_script.sh
You can write the following in your script:

    #!/bin/sh
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

**Q** Modify your script by adding `>>` after the loop and specify a file where the output would be saved.

Show me the answer!


    #!/bin/sh
    # a for-loop to print text and numbers from 0 to 10
    for num in {1..10}; do
    echo 'day '$num ':has been cool!'
    done >> my_output.txt
    Check the output file that was created with less my_output.txt

We can go a bit further and modify our script to make it interactive by allowing the script to get some of its
arguments directly in the command line.
Modify the script by replacing ':has been cool!' by `${1}` and my_output by `${2}`:

    #!/bin/sh
    # a for-loop to print text and numbers from 0 to 10
    for num in {1..10}; do
    echo 'day '$num ${1}
    done >> ${2}.txt

Save the changes and exit the script.

OK, what is goint on here?

The `${1}` and `${2}` variables correspond to the first and second argument we will specify
in the command line when running the script. Let's say we want to specify a different text for the result of the day ':has been cool!' and change it to 'great' and to save it in a different file called 'output2.txt', then we need to provide those arguments in the command line.

    bash my_script.sh great output2

Now the new output file 'output2.txt' should have the word 'great' instead of the initial ':has been cool!'.

**Q** Compare `my_output.txt` and `output2.txt`

Show me the answer!

    cat my_output.txt
    cat output2.txt


