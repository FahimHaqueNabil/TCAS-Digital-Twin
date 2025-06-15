% Trajectories
trajectory1 = [];
trajectory2 = [];

% Main loop
for i = 1:length(t)
    % Update positions
    position_A(1) = position_A(1) + velocity_A * dt;
    position_B(1) = position_B(1) - velocity_B * dt;

    % Compute horizontal distance
    horizDist = abs(position_A(1) - position_B(1));

    % Compute relative velocity and tcpa
    rel_vel = velocity_B + velocity_A;
    tcpa = horizDist / rel_vel;

    fprintf("Distance between Aircraft A and B: %.0f m\n", horizDist);

    % TA detection
    if horizDist < TA_threshold && ~TA_region && ~RA_region && tcpa > 0 && tcpa < tCPA_TA
        TA_region = true;
        advisoryMessage = ['[TA] Traffic Advisory at t = ' num2str(t(i)) ' sec'];
        disp(advisoryMessage);
    end

    % RA detection
    if horizDist < RA_threshold && ~RA_region && tcpa < tCPA_RA
        RA_region = true;
        advisoryMessage = ['[RA] Resolution Advisory at t = ' num2str(t(i)) ' sec'];
        disp(advisoryMessage);
    end

    % RA maneuver
    if RA_region
        if horizDist > RA_threshold
            position_A(3) = moveToAltitude(position_A(3), 10000, returnRate, dt);
            position_B(3) = moveToAltitude(position_B(3), 10000, returnRate, dt);
            if abs(position_A(3) - 10000) < 5 && abs(position_B(3) - 10000) < 5
                RA_region = false;
                TA_region = false;
                advisoryMessage = ['[RESOLVED] Conflict resolved at t = ' num2str(t(i)) ' sec'];
                disp(advisoryMessage);
            end
        else
            position_A(3) = position_A(3) + climbRate_RA * dt;
            position_B(3) = position_B(3) - climbRate_RA * dt;
        end
    end

    % Track climb/descent
    verticalChange_A = position_A(3) - initialAltitude_A;   % Climb
    verticalChange_B = initialAltitude_B - position_B(3);   % Descent

    % Update label
    labelText = sprintf([ ...
        'Aircraft A (Blue) Speed: %d m/s\n' ...
        'Aircraft B (Red) Speed: %d m/s\n' ...
        'Horizontal Distance between Aircraft A and B: %.0f m\n' ...
        'Vertical Distance between Aircraft A and B: %.0f m\n' ...
        'Aircraft A Climb: %.1f m\n' ...
        'Aircraft B Descent: %.1f m\n' ...
        '%s'], ...
        velocity_A, velocity_B, horizDist, ...
        (verticalChange_A+verticalChange_B), verticalChange_A, verticalChange_B, advisoryMessage);

    set(labelHandle, 'String', labelText);

    % Store trajectory
    trajectory1(end+1, :) = position_A;
    trajectory2(end+1, :) = position_B;

    % Update plots
    set(h1, 'XData', position_A(1), 'YData', position_A(2), 'ZData', position_A(3));
    set(h2, 'XData', position_B(1), 'YData', position_B(2), 'ZData', position_B(3));
    set(trail1, 'XData', trajectory1(:,1), 'YData', trajectory1(:,2), 'ZData', trajectory1(:,3));
    set(trail2, 'XData', trajectory2(:,1), 'YData', trajectory2(:,2), 'ZData', trajectory2(:,3));

    drawnow;
    pause(0.05);
end

% Helper function
function newAlt = moveToAltitude(current, target, rate, dt)
    if abs(current - target) < rate * dt
        newAlt = target;
    elseif current < target
        newAlt = current + rate * dt;
    else
        newAlt = current - rate * dt;
    end
end
