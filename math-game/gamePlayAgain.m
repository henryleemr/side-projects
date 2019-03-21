function gamePlayAgain(score);

disp('Welcome to the game!')
disp('------------------------------------')
disp('MENU')
disp('------------------------------------')
disp('Press a number to pick a game mode')
disp('------------------------------------')
disp('1.Addition')
disp('2.Subtraction')


disp('        ')

pickNumber=input('Please enter the number displayed to choose: ')

switch pickNumber   %reverts the choices to the specific function that corresponds to an addition, subtraction or division game in a separate file
    case 1
        additionGame(score);
    case 2
        subtractionGame(score);
   
end

