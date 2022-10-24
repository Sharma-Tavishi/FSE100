%%% Navigation Code

%--Auto_ULTRASONIC SENSOR
                if(turnCounter == 1 && turnBuffer >= 1)
                    turnTimer = tic; % starts timer
                    turnBuffer = 1.0;
                end
                if(turnTimer >= .5 && turnCounter == 1)                    
                    turnCounter = 0;
                    turnBuffer = 1.5;
                end
                
                distance = brick.UltrasonicDist(1);  % Get distance to the nearest object.                
                if(distance > 45) %
                    if(timerStarted_Ultra == false)
                        timerStarted_Ultra = true;                            
                        timerVal_Ultra = tic; %starts timer  
                    end      
                        
                    if(timerVal_Ultra >= turnBuffer)
                        disp("No Right wall detected Turning Right");
                        timerVal_TurnTime = tic; %starts timer
                        state = 4;
                    end
%Auto_COLOR SENSOR
color = brick.ColorColor(4);                                            
                 if(color == 5) % Color Red is Detected
                     if(distance > 45)
                         turnBuffer = 1.0;%if stopped and red reduce turn buffer time.
                     end
                     disp("Red Detected: Switching to Manual Control");
                     timerVal = tic;
                     state = 3;
                 end
                 
                 if(color == 4 && yellowFound == false) % Color Yellow is Detected
                     yellowFound = true;
                     brick.StopAllMotors();
                     disp("Yellow Detected: Switching to Manual Control");
                     manualControl = true;
                 end    
                                
                 if(color == 3 && blueFound == true) % Color Green is Detected
                      brick.StopAllMotors();
                      disp("Green Detected: Switching to Manual Control");
                      manualControl = true;     
                   end
%MANUAL CONTROL

if(manualControl == true)
        switch key
            case 'uparrow' %Move Forward
                   %disp(mUpArrow);
                   brick.MoveMotor('AD', manual_Speed_Forward);
            case 'downarrow'%Move Backwards
                brick.MoveMotor('AD', manual_Speed_Backwards);
            case 'leftarrow'
                brick.MoveMotor('A', manual_Speed_TurnSpeed);%Left turn
                brick.StopMotor('D');
            case 'rightarrow'
                brick.MoveMotor('D', manual_Speed_TurnSpeed);%Right turn
                brick.StopMotor('A');
            case 'backspace' %Stops all movement
                brick.StopMotor('AD');
                end
                
            case 'a' %Switches back to automatic control
                manualControl = false;
           
    end
    if(key == 'q')%Quit the program
        brick.StopAllMotors();
        break;
    end
end
CloseKeyboard();
