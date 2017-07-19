-- These are the configuration variables, set them according to your system
modelCmd = '0'        -- Panasonic CKP, see https://github.com/mysensors/Arduino/blob/development/libraries/MySensors/examples/HeatpumpIRController/HeatpumpIRController.ino#L68
commandArray = {}


for key, value in pairs(devicechanged) do
  if (key == 'Heatpump Mode' or key == 'Heatpump Fan Speed' or key == 'Heatpump Temperature') then

    mode = otherdevices['Heatpump Mode']
    fanSpeed = otherdevices['Heatpump Fan Speed']
    temperature = math.floor(otherdevices_svalues['Heatpump Temperature'])

    if     (mode == 'Off')   then powerModeCmd = '00'
    elseif (mode == 'Auto')  then powerModeCmd = '11'
    elseif (mode == 'Heat')  then powerModeCmd = '12'
    elseif (mode == 'Cool')  then powerModeCmd = '13'
    elseif (mode == 'Dry')   then powerModeCmd = '14'
    elseif (mode == 'Fan')   then powerModeCmd = '15'
    elseif (mode == 'Maint') then powerModeCmd = '16'
    end

    if     (fanSpeed == 'Auto')  then fanSpeedCmd = '0'
    elseif (fanSpeed == 'Fan 1') then fanSpeedCmd = '1'
    elseif (fanSpeed == 'Fan 2') then fanSpeedCmd = '2'
    elseif (fanSpeed == 'Fan 3') then fanSpeedCmd = '3'
    elseif (fanSpeed == 'Fan 4') then fanSpeedCmd = '4'
    elseif (fanSpeed == 'Fan 5') then fanSpeedCmd = '5'
    end

    temperatureCmd = string.format("%02x", temperature)

    modeCmd = '00' .. modelCmd .. powerModeCmd .. fanSpeedCmd .. temperatureCmd

    print(string.format('Mode: %s, fan: %s, temp: %s, modeCmd: %s', mode, fanSpeed, temperature, modeCmd))

    commandArray['UpdateDevice'] = otherdevices_idx['IR data'] .. '|0|' .. modeCmd
    os.execute('/home/chip/build/433Utils/CHIP_utils/codesend "'..modeCmd..'" 2')

  end
end

return commandArray

