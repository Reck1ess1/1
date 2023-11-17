function displayStatistics(nodes)
    numNodes = length(nodes);
    totalPacketsSent = 0;
    totalDelay = 0;

    for i = 1:numNodes
        packetsSent = length(nodes(i).packetQueue);
        totalPacketsSent = totalPacketsSent + packetsSent;
        fprintf('Node %d sent %d packets.\n', i, packetsSent);

        % 假设每个数据包的时延是随机的，这里只是为了示例
        for j = 1:packetsSent
            delay = rand(); % 随机生成时延
            totalDelay = totalDelay + delay;
        end
    end

    averageDelay = totalDelay / totalPacketsSent;
    fprintf('Total packets sent: %d\n', totalPacketsSent);
    fprintf('Average packet delay: %.2f\n', averageDelay);

    % 这里可以添加更多的统计信息，如抖动、丢包率等
end