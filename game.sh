#!/bin/bash

# insert players name
read -p "Insert player 1 name: " player1
read -p "Insert player 2 name: " player2

# p1 & p2 have to insert their number 
while true; do
    read -s -p "$player1, set your 4-digit secret number (0000-9999): " secretNumber1
    echo
    # Validate the number
    if [[ ! "$secretNumber1" =~ ^[0-9]{4}$ ]]; then
        echo "Invalid number. Please enter a 4-digit number between 0000 and 9999."
    else
        break
    fi
done

while true; do
    read -s -p "$player2, set your 4-digit secret number (0000-9999): " secretNumber2
    echo
    # verified the number
    if [[ ! "$secretNumber2" =~ ^[0-9]{4}$ ]]; then
        echo "Invalid number. Please enter a 4-digit number between 0000 and 9999."
    else
        break
    fi
done

# Start the loop
echo "Game starts!"
attempts1=()
attempts2=()
round=1
gameOver=false

while true; do
    echo "Round $round"

    # p1 list atempts
    if [ ${#attempts1[@]} -gt 0 ]; then
        echo "Previous attempts by $player1:"
        for attempt in "${attempts1[@]}"; do
            echo "Previous guess: $attempt"
        done
    fi

    # p1 turn 
    echo "$player1's turn:"
    read -p "Make your guess (4 digits): " guess1

    # verified p1 guess
    if [[ ! "$guess1" =~ ^[0-9]{4}$ ]]; then
        echo "Invalid number. Please enter a 4-digit number between 0000 and 9999."
        continue
    fi

    # count
    correctPosition1=0
    correctNumber1=0
    usedInGuess1=()
    usedInSecret1=()

    # check the number
    for ((i=0; i<4; i++)); do
        if [[ "${secretNumber2:i:1}" == "${guess1:i:1}" ]]; then
            correctPosition1=$((correctPosition1 + 1))
            usedInGuess1[i]=1
            usedInSecret1[i]=1
        fi
    done

    # check perfects
    for ((i=0; i<4; i++)); do
        if [[ ! "${usedInGuess1[i]}" ]]; then
            for ((j=0; j<4; j++)); do
                if [[ ! "${usedInSecret1[j]}" && "${secretNumber2:j:1}" == "${guess1:i:1}" ]]; then
                    correctNumber1=$((correctNumber1 + 1))
                    usedInSecret1[j]=1
                    break
                fi
            done
        fi
    done

    # results
    attempts1+=("$guess1: $correctPosition1 perfect, $correctNumber1 well")
    echo "$player1, your guess: $guess1"
    echo "Perfect digits: $correctPosition1"
    echo "Well digits: $correctNumber1"

    # Check if player 1 has guessed the secret number
    if [[ "$guess1" == "$secretNumber2" ]]; then
        echo "$player1 has guessed the number! Now $player2 has one last chance to guess."
        gameOver=true
    fi

    # p2 previous attemps
    if [ ${#attempts2[@]} -gt 0 ]; then
        echo "Previous attempts by $player2:"
        for attempt in "${attempts2[@]}"; do
            echo "Previous guess: $attempt"
        done
    fi

    # p2 turn
    echo "$player2's turn:"
    read -p "Make your guess (4 digits): " guess2

    # Validate the guess
    if [[ ! "$guess2" =~ ^[0-9]{4}$ ]]; then
        echo "Invalid number. Please enter a 4-digit number between 0000 and 9999."
        continue
    fi

    # count
    correctPosition2=0
    correctNumber2=0
    usedInGuess2=()
    usedInSecret2=()

    # check
    for ((i=0; i<4; i++)); do
        if [[ "${secretNumber1:i:1}" == "${guess2:i:1}" ]]; then
            correctPosition2=$((correctPosition2 + 1))
            usedInGuess2[i]=1
            usedInSecret2[i]=1
        fi
    done

    # check2 
    for ((i=0; i<4; i++)); do
        if [[ ! "${usedInGuess2[i]}" ]]; then
            for ((j=0; j<4; j++)); do
                if [[ ! "${usedInSecret2[j]}" && "${secretNumber1:j:1}" == "${guess2:i:1}" ]]; then
                    correctNumber2=$((correctNumber2 + 1))
                    usedInSecret2[j]=1
                    break
                fi
            done
        fi
    done

    # results p2 
    attempts2+=("$guess2: $correctPosition2 perfect, $correctNumber2 well")
    echo "$player2, your guess: $guess2"
    echo "Perfect digits: $correctPosition2"
    echo "Well digits: $correctNumber2"

    # check p2 have a correct guess?
    if [[ "$guess2" == "$secretNumber1" ]]; then
        echo "$player2 guessed the number! $player2 wins!"
        break
    fi

    # check game over, player 2, have the final guess. 
    if [[ "$gameOver" == true ]]; then
        echo "$player2 failed to guess. $player1 wins!"
        break
    fi

    round=$((round + 1))  #looping
done
