# Mastermind Game

## Introduction

This is a text-based Mastermind game that was made as part of [The Odin Project](https://www.theodinproject.com). This project is written in Ruby.

The project details can be found at [Project: Mastermind](https://www.theodinproject.com/lessons/ruby-mastermind).

For more details on how to play the game, see [Mastermind (board game)](<https://en.wikipedia.org/wiki/Mastermind_(board_game)>)

## How to Play

There are two modes that you can play:

- **Code Breaker**: A secret code is randomly generated and you try to figure it out by entering different codes and observing the feedback for each. You have 8 chances in order to figure out the code.

- **Code Maker**: You pick a secret code and the Computer will try to guess it within 8 turns.

All codes that you enter must be 4 digits long and consist of these characters: A, B, C, D, E, F

Duplicate characters are allowed and the input is case insensitive. Here are some examples of valid codes:

- aabc

- CCDD

- ABCD

## About the Feedback

After each attempt, feedback will be presented with a 4 character string with the following information for each code in the guess attempt:

- B: A code was guessed correctly and was in the correct position.
- W: A code was guessed correctly but was in the wrong position.
- \-: A code is not part of the secret code.

The feedback will not specify which codes are the correct ones, just that there exists correct codes. The order of the 'B', 'W', and '\-' feedback do not provide information about each code. The 'B' characters will appear first, followed by the 'W' characters, followed by the '\-' characters. One single code cannot have both a 'B' and a 'W' value, it's either one or the other.

Note: 'B' means black and 'W' means white.

**An example game:**

The computer generates the following secret code:

- FAAE

The player makes this guess on the first turn:

- AABB

This will result in the following feedback:

- BW\-\-

The 'B' is there because one 'A' is correct and is in the correct position. The 'W' is there because there is an 'A' (different from the first 'A') that is correct, but it is in the wrong position. If the guess had included a third 'A', that would have been represented with a '\-' character.

Say the player makes this guess on the second turn:

- CCDD

This will result in the following feedback:

- \-\-\-\-

This means none of the codes entered are present in the secret code. If later on, the player guesses this:

- AAEB

This will result in this feedback:

- BBB-

If the player succeeds in guessing the correct turn within 8 turns (gets feedback of 'BBBB'), then the player wins, otherwise loses.

## More Details

For the Code Maker part of the game, the Computer uses a partial implementation of an algorithm created by Donald Knuth. More details about this algorithm can be seen at [Mastermind-Five-Guess-Algorithm](https://github.com/NathanDuran/Mastermind-Five-Guess-Algorithm).

The only part of the algorithm that is not implemented is step 6, the "Apply minimax technique" step. Instead of doing that, this game will just pick a random code out of Set S for each subsequent choice.

Even without the minimax technique, the Computer virtually wins every Code Maker game.
