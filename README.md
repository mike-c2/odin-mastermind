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

## More Details

For the Code Maker part of the game, the Computer uses a partial implementation of an algorithm created by Donald Knuth. More details about this algorithm can be seen at [Mastermind-Five-Guess-Algorithm](https://github.com/NathanDuran/Mastermind-Five-Guess-Algorithm).

The only part of the algorithm that is not implemented is step 6, the "Apply minimax technique" step. Instead of doing that, this game will just pick a random code out of Set S for each subsequent choice.

Even without the minimax technique, the Computer virtually wins every Code Maker game.
