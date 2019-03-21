function subtractionGame(score) %when choosing the type of game, pressing 1 will lead to the activation of this function

disp('You have selected Subtraction Game!')

disp('Your score is')
disp(score)

    
    FirstNumber= round(rand(1)*5); %round the random 1 by 1 matrix, ie, a decimal number, multiplied by 6 to give it a nice integer between 0 and 10
    SecondNumber= round(rand(1)*10);
    
    numberAnswer = FirstNumber-SecondNumber;
    
    fprintf('What is %g - %g ? \n',FirstNumber,SecondNumber) %display 'what is %g + %g ? and then space' where first %g is FirstNumber and second %g is SecondNumber
    
    PlayerAnswer=input('Please key in the answer:');
    
    if PlayerAnswer==numberAnswer;
       
        disp('Congratulations! You Won!')
        
        score=score+1;
        
        disp('Your New Score is')
        
        disp(score)
        
        disp('   ')
        
        disp('Would you like to play again?')
        
        disp('   ')
        
        disp('Press 1 if you would like to play again, 2 for Menu, 3 to exit')
        
        gameAgain=input('Please type your choice here:');
        
        switch gameAgain  
            case 1
            subtractionGame(score);
            case 2
            gamePlayAgain(score);
            case 3
            endGame();
            otherwise
            disp('please pick either 1,2 or 3');
        end
        
      
    else
    
        
        fprintf('Sorry, that is the wrong answer') %could improve by displaying the correct answer. ie numberAnswer
        
        disp('      ')
        
        disp('Would you like to play again?')
        
        disp('Press 1 if you would like to play again, 2 for Menu, 3 to exit')
        
        gameAgain=input('Please type your choice here:');
        
    switch gameAgain  
        case 1
        subtractionGame(score);
        case 2
        gamePlayAgain(score);
        case 3
        endGame();
        otherwise
        disp('please pick either 1,2 or 3');
    end
    
    end

end
    

