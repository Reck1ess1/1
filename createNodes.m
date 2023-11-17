function nodes = createNodes(numNodes, fieldSize, numBeamDirections, minDistance)
    % 定义节点结构体
    nodes = struct('id', cell(1, numNodes), 'position', cell(1, numNodes), ...
                   'beamDirection', cell(1, numNodes), 'packetQueue', cell(1, numNodes), ...
                   'sentPackets', cell(1, numNodes), 'receivedPackets', cell(1, numNodes), ...
                   'delaySum', cell(1, numNodes), 'lastReceivedTime', cell(1, numNodes));
    % 初始化节点属性
    for i = 1:numNodes
        isValidPosition = false;
        while ~isValidPosition
            position = rand(1, 2) * fieldSize; % 随机位置
            isValidPosition = true;
            for j = 1:i-1
                if norm(position - nodes(j).position) < minDistance
                    isValidPosition = false;
                    break;
                end
            end
        end
        nodes(i).id = i;
        nodes(i).position = position;
        nodes(i).beamDirection = randi([1, numBeamDirections]); % 随机波束方向
        nodes(i).packetQueue = []; % 初始化数据包队列
        nodes(i).sentPackets = 0;
        nodes(i).receivedPackets = 0;
        nodes(i).delaySum = 0;
        nodes(i).lastReceivedTime = [];
    end
end