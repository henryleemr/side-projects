disp('Welcome to the game!')
disp('------------------------------------')
disp('MENU')
disp('------------------------------------')
disp('Press a number to pick a game mode')
disp('------------------------------------')
disp('1.Addition')
disp('2.Subtraction')


disp('        ')

gameChoice=input('Please enter the number displayed to choose: ');

switch gameChoice   %reverts the choices to the specific function that corresponds to an addition, subtraction or division game in a separate file
    case 1
        additionGame(0);
    case 2
        subtractionGame();
    
    otherwise
        disp('please pick either 1 or 2');
end


%improvements: 1.layout of messages. maybe add some more spaces and lines
%2. improve the readability and convention of the code 3.include a correct
%answer if the asnwer given is wrong 4.add animations when congratulating
%for correct answer 5.fix the endGame problem.


