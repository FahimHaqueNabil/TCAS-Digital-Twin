% Trajectories
trajectory1 = [];
trajectory2 = [];

% Create on-screen text box once (top-left corner)
infoBoxHandle = annotation('textbox', [0.02, 0.75, 0.3, 0.2], ...
    'String', '', ...
    'FontSize', 11, ...
    'BackgroundColor', 'white', ...
    'EdgeColor', 'black', ...
    'FitBoxToText', 'on');

% Main loop
for i = 1:length(t)
    % Update positions
    position_A(1) = position_A(1) + velocity_A * dt;
    position_B(1) = position_B(1) - velocity_B * dt;

    % Compute horizontal distance
    horizDist = abs(position_A(1) - position_B(1));

      % Compute relative velocity
    rel_vel = velocity_B + velocity_A;
     % Compute CPA
    tcpa = dot(horizDist, rel_vel) / norm(rel_vel)^2;     
   
    fprintf("Distance Between Aircraft A and Aircraft B : %.0f m\n", horizDist);

    % TA detection    
    if horizDist < TA_threshold && ~TA_region && ~RA_region && tcpa > 0 && tcpa < tCPA_TA
        TA_region = true;
        advisoryMessage = ['Advisory: [TA] Traffic Advisory at t = ' num2str(t(i)) ' sec'];
        TA_sent = true;
        % fprintf("Aircraft A position %.1f and Aircraft B position: %.1f\n", position_A(1), position_B(1));
         fprintf("TA: Distance Between Aircraft A and Aircraft B is : %.1f m\n", horizDist); 
    end

    % RA detection    
    if horizDist < RA_threshold && ~RA_region  && tcpa < tCPA_RA
        RA_region = true;
        advisoryMessage = ['Advisory: [RA] Resolution Advisory at t = ' num2str(t(i)) ' sec'];
        RA_sent = true;
         %fprintf("Aircraft A position %.1f and Aircraft B position: %.1f\n", position_A(1), position_B(1));
         fprintf("RA: Distance Between Aircraft A and Aircraft B is: %.1f m\n", horizDist);
    end

    % TA  Advisory sent again if not sent  
    if horizDist < TA_threshold && TA_region && ~TA_sent && ~RA_region && tcpa > 0 && tcpa < tCPA_TA       
        advisoryMessage = ['Advisory: [TA] Traffic Advisory again at t = ' num2str(t(i)) ' sec'];
        TA_sent = true;
         fprintf("TA: Distance Between Aircraft A and Aircraft B is : %.1f m\n", horizDist); 
    end

    % RA Advisory sent again if not sent    
    if horizDist < RA_threshold && RA_region && ~RA_sent  && tcpa < tCPA_RA
        advisoryMessage = ['Advisory: [RA] Resolution Advisory again at t = ' num2str(t(i)) ' sec'];
        RA_sent = true;
        fprintf("RA: Distance Between Aircraft A and Aircraft B is: %.1f m\n", horizDist);
    end

    % RA maneuver
    if RA_region
        if horizDist > RA_threshold
            position_A(3) = moveToAltitude(position_A(3), 10000, returnRate, dt);
            position_B(3) = moveToAltitude(position_B(3), 10000, returnRate, dt);
            if abs(position_A(3) - 10000) < 5 && abs(position_B(3) - 10000) < 5
                RA_region = false;
                TA_region = false;

                TA_sent = false;
                RA_sent = false;
                advisoryMessage = ['Advisory: [RESOLVED] Conflict resolved at t = ' num2str(t(i)) ' sec'];
            end
        else
            position_A(3) = position_A(3) + climbRate_RA * dt;
            position_B(3) = position_B(3) - climbRate_RA * dt;
            fprintf("RA: Aircraft A : Climb and Aircraft B : Descend");
            advisoryMessage = ['Advisory: [RA] Aircraft A : Climb and Aircraft B : Descend'];
        end
    end

    % Store trajectory
    trajectory1(end+1, :) = position_A;
    trajectory2(end+1, :) = position_B;

    % Update plot markers
    set(h1, 'XData', position_A(1), 'YData', position_A(2), 'ZData', position_A(3));
    set(h2, 'XData', position_B(1), 'YData', position_B(2), 'ZData', position_B(3));
    set(trail1, 'XData', trajectory1(:,1), 'YData', trajectory1(:,2), 'ZData', trajectory1(:,3));
    set(trail2, 'XData', trajectory2(:,1), 'YData', trajectory2(:,2), 'ZData', trajectory2(:,3));

    % Update advisory label
    infoText = sprintf([ ...
        'Aircraft A Speed: %d m/s\n' ...
        'Aircraft B Speed: %d m/s\n' ...
        'Distance Between Aircraft A and Aircraft B is : %.2f m\n' ...
        '%s'], ...
        velocity_A, velocity_B, horizDist, advisoryMessage);
    set(infoBoxHandle, 'String', infoText);

    drawnow;
    pause(0.1);

end

% Helper function: move to target altitude
function newAlt = moveToAltitude(current, target, rate, dt)
    if abs(current - target) < rate * dt
        newAlt = target;
    elseif current < target
        newAlt = current + rate * dt;
    else
        newAlt = current - rate * dt;
    end
end
