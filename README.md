# CMG test
[test description](https://github.com/noslopy/cmg_test/files/5093404/CMG.-.Engineering.Audition.pdf)

## details
* ruby version: 2.7.1 (rbenv)
* timeframe: 4hrs

After using rails and sinatra and other frameworks to build ruby based test assignments, I have decided to create just a pure ruby script
because I didn't want to spend more time on it.

The keyword for this project is "strategy". I designed most parts of this script according to strategy pattern.
Altough I have implemented most parts to be modular and malleable, in case of a new sensor the codebase must be updated to handle new evaluation rules.

## updateability

I didn't prepare the script for changes in the log's format. As the current code suggests it could be done by creating formatting rules following the
concept implemented in the script.


## running the ruby script

```bash
$ ruby parser.test.rb
```