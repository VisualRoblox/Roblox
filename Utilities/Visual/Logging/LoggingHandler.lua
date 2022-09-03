local LoggingHandler = {}

function LoggingHandler.Error(Error)
    error('[ Visual ] Error: ' .. Error )
end

function LoggingHandler.Log(Message)
    print('[ Visual ] ' .. Message)
end

function LoggingHandler.Warn(Message)
    warn('[ Visual ] Warning: ' .. Message)
end

return LoggingHandler