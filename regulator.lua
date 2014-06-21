ReactorRegulator = {
    turbine = peripheral.wrap("left"),
    reactorPowerSide = "right"
}

function ReactorRegulator:setReactorEnabled(state)
    rs.setOutput(self.reactorPowerSide, state)
end

function ReactorRegulator:getReactorEnabled()
    return rs.getOutput(self.reactorPowerSide)
end

ReactorRegulator_mt = {__index = ReactorRegulator}

regulator = ReactorRegulator

regulator.updateTimer = os.startTimer(1)
while true do
    local event, param1, param2, param3 = os.pullEvent()

    if event == "timer" then
        if regulator.updateTimer == param1 then
            if regulator:getReactorEnabled() then
                if regulator.turbine.getEnergyStored() > (0.4 * 1000000) then
                    regulator:setReactorEnabled(false)
                    print("Powered off Reactor")
                end
            elseif regulator.turbine.getEnergyStored() < (0.2 * 1000000) then
                    regulator:setReactorEnabled(true)
                    print("Powered on Reactor")
            end
            regulator.updateTimer = os.startTimer(10)
        end
    end
end
