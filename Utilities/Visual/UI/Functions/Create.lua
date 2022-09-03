local CreateHandler = {}

function CreateHandler.Create(InstanceName, Properties, Children)
    local Object = Instance.new(InstanceName)
    local Properties = Properties or {}
    local Children = Children or {}
    
    for Index, Property in next, Properties do
        Object[Index] = Property
    end

    for _, Child in next, Children do
        Child.Parent = Object
    end

    return Object
end

return CreateHandler.Create