clear
% 示例：n 个节点的坐标
numNodes = 8;
fieldSize = 300; % 300km x 300km
numBeamDirections = 4; % 假设有8个波束方向
minDistance = 30; % 最小距离为5km
r =200;  %通信范围 单位km
theta = pi/8;                             % 波束宽度
B = 2*pi/theta;                           % 可选择的波束方向个数   
currentTime = 0; % 当前时间
numCycles = 3; % 模拟的周期数
cycleDuration = 10; % 每个周期的持续时间
packetGenerationProbability = 0.5; % 节点生成数据包的概率
timeSlot = 1; % 每个时隙的持续时间



% 创建节点
nodes = createNodes(numNodes, fieldSize, numBeamDirections, minDistance);

%%%%%判断波束指向以及可能的邻居节点%%%%%%
for i = 1:numNodes
    for j = 1:numNodes
          tx = nodes(i).position(1)-nodes(j).position(1);%坐标矩阵第一列（横坐标）、坐标矩阵第二列（纵坐标）
          ty = nodes(i).position(2)-nodes(j).position(2);
        angle(i,j) = atan2(ty,tx)+pi;
        if i~= j     
            beam = fix(angle(i,j)/theta)+1;   %向下取整，得到扇区编号
            if beam == B+1
                beam = 1;   %防溢出
            end
            J(i,j) = beam;                % 邻居节点j在节点i的beam方向，    更新节点之间的关系矩阵
        end
    end
    N(i) = length(find(J(i,:)~=0));       % 节点i的邻居节点总数
end
NN = round(mean(N));                      % 节点的邻居总数的平均值，四舍五入取整



% 创建邻接矩阵
adjMatrix = zeros(numNodes, numNodes);
for i = 1:numNodes
    for j = 1:numNodes
        if i ~= j
            distance = norm(nodes(i).position - nodes(j).position);
            adjMatrix(i, j) = distance; % 距离作为权重
        end
    end
end


% 模拟多周期数据传输
for cycle = 1:numCycles
    fprintf('Cycle %d\n', cycle);
    for i = 1:numNodes
        if rand <= packetGenerationProbability
            % 该节点在这个周期生成数据包
            fprintf('Node %d generates a packet\n', i);
            % 将数据包添加到节点的队列中
            nodes(i).packetQueue = [nodes(i).packetQueue, generatePacket(i, randi(numNodes))];
        end
    end

    % 使用 Dijkstra 算法处理每个节点的数据包队列
    for i = 1:numNodes
        if ~isempty(nodes(i).packetQueue)
            [distances, paths, nodes] = dijkstraWithPacketProcessing(adjMatrix, i, nodes, cycle * cycleDuration);
            % ... 可以在这里处理 distances 和 paths 的输出
            
        end
    end

    % 等待下一个周期
    pause(cycleDuration);
end








% 显示统计信息
displayStatistics(nodes);


% 可视化节点位置
figure;
hold on;
for i = 1:numNodes
    plot(nodes(i).position(1), nodes(i).position(2), 'o');
    text(nodes(i).position(1), nodes(i).position(2), sprintf(' %d', i), 'VerticalAlignment', 'bottom');
end
title('节点位置分布');
xlabel('X 坐标 (km)');
ylabel('Y 坐标 (km)');
xlim([0, fieldSize]);
ylim([0, fieldSize]);
grid on;
hold off;

% 显示路由表
for i = 1:numNodes
    fprintf('节点 %d 的路由表: ', i);
    disp(routingTable{i});
end