function packet = generatePacket(source, destination)
    % 创建一个简单的数据包结构体
    packet = struct('source', source, 'destination', destination, 'data', rand(1,10)); % 示例数据
end