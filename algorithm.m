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

    % TA detection
    if horizDist < TA_threshold && ~TA_region && ~RA_region
        TA_region = true;
        disp(['[TA] Traffic Advisory at t = ' num2str(t(i)) ' sec']);
    end

    % RA detection
    if horizDist < RA_threshold && ~RA_region
        RA_region = true;
        disp(['[RA] Resolution Advisory at t = ' num2str(t(i)) ' sec']);
    end

    % RA maneuver
    if RA_region
        if horizDist > RA_threshold
            position_A(3) = moveToAltitude(position_A(3), 10000, returnRate, dt);
            position_B(3) = moveToAltitude(position_B(3), 10000, returnRate, dt);
            if abs(position_A(3) - 10000) < 5 && abs(position_B(3) - 10000) < 5
                RA_region = false;
                TA_region = false;
                disp(['[RESOLVED] Conflict resolved at t = ' num2str(t(i)) ' sec']);
            end
        else
            position_A(3) = position_A(3) + climbRate_RA * dt;
            position_B(3) = position_B(3) - climbRate_RA * dt;
        end
    end

    % Store trajectory
    trajectory1(end+1, :) = position_A;
    trajectory2(end+1, :) = position_B;

    % Update plots
    set(h1, 'XData', position_A(1), 'YData', position_A(2), 'ZData', position_A(3));
    set(h2, 'XData', position_B(1), 'YData', position_B(2), 'ZData', position_B(3));
    set(trail1, 'XData', trajectory1(:,1), 'YData', trajectory1(:,2), 'ZData', trajectory1(:,3));
    set(trail2, 'XData', trajectory2(:,1), 'YData', trajectory2(:,2), 'ZData', trajectory2(:,3));

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