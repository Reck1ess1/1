function [distances, paths, nodes] = dijkstraWithPacketProcessing(adjMatrix, startNode, nodes, startTime)
    numNodes = size(adjMatrix, 1);
    distances = inf(numNodes, 1);
    distances(startNode) = 0;
    visited = false(numNodes, 1);
    paths = num2cell(NaN(numNodes, 1));

    while true
        % 选择未访问的距离最小的节点
        [~, u] = min(distances .* (~visited));
        if distances(u) == inf
            break;
        end
        visited(u) = true;

        % 更新邻居节点的距离和路径
        for v = 1:numNodes
            if adjMatrix(u, v) > 0 && ~visited(v)
                alt = distances(u) + adjMatrix(u, v);
                if alt < distances(v)
                    distances(v) = alt;
                    paths{v} = [paths{u}, u];
                end
            end
        end
    end

    % 处理数据包传输
    for i = 1:numNodes
        if ~isempty(nodes(i).packetQueue)
            % 假设数据包传输到达目的地
            packet = nodes(i).packetQueue(1);
            destination = packet.destination; % 假设数据包结构体中有目的地字段
            % 检查路径是否包含当前节点
            if any(paths{destination} == i)
                % 假设处理数据包
                % ... 数据包处理逻辑
                % 移除已处理的数据包
                nodes(i).packetQueue(1) = [];
            end
        end
    end
end