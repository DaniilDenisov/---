% Finite element mesh class.
% Copyright 2017 Daniil S. Denisov
classdef FEMesh < handle
    properties (Access = public)
        numberOfElems;
        numberOfNodes;
        numberOfBCs;
        dofPerNode;
        % Element matrix coincidense. Nodal DOFs to global indices.
        iM;
        % Nodal coincidense matrix. Nodal DOFs to global indices.
        iMnod;
        allMeshElems;
        allNodes;
        allBCs;
    end
    methods
        % Read mesh file (Constructor).
        function obj = FEMesh(filename)
            % Read line with stored array sizes.
            totalLine = dlmread(filename,',',[0 0 0 2]);
            % Parse array sizes line.
            obj.numberOfElems = totalLine(1);
            obj.numberOfNodes = totalLine(2);
            obj.numberOfBCs = totalLine(3);
            fprintf('Els:%d Nodes:%d BCs:%d\n', obj.numberOfElems,...
                obj.numberOfNodes, obj.numberOfBCs);
            % Read all data arrays.
            allElemsTmp = dlmread(filename,',',...
                [1 0 obj.numberOfElems 5]);
            obj.allNodes = dlmread(filename,',',...
                [obj.numberOfElems+1 0 ...
                obj.numberOfNodes+obj.numberOfElems 2]);
            obj.allBCs = dlmread(filename,',',...
                [obj.numberOfNodes+obj.numberOfElems+1 0 ...
                obj.numberOfNodes+obj.numberOfElems+obj.numberOfBCs 5]);
            % Preallocate full set of empty finite elements.
            elemArrTmp(obj.numberOfElems,1) = Truss2DElement();
            obj.allMeshElems = elemArrTmp;
            % Fill in the data into finite elements created.
            for i=1:obj.numberOfElems
                % Select next line containing finite element data.
                currElem = allElemsTmp(i,:);
                % Parse data string. Get the type of element.
                currType = currElem(1);
                % Node numbers.
                currNode1 = currElem(2);
                currNode2 = currElem(3);
                % Data fields: area, Young modulus, ���������.
                currArea = currElem(4);
                currEmod = currElem(5);
                currRho = currElem(6);
                % ���������� �����.
                currNode1_XYZ = [obj.allNodes(currNode1,1) ...
                    obj.allNodes(currNode1,2) ...
                    obj.allNodes(currNode1,3)];
                currNode2_XYZ = [obj.allNodes(currNode2,1) ...
                    obj.allNodes(currNode2,2) ...
                    obj.allNodes(currNode2,3)];
                % ���������� ������� �������� � ������� FE��sh �
                % ���������� ������ ������� ������������ iM.
                switch currType
                    % ��� �������� ���� 112.
                    case 112
                        obj.allMeshElems(i).SetupElement(...
                            [currNode1_XYZ; currNode2_XYZ],...
                            [currNode1,currNode2], ...
                            [currArea, currEmod, currRho]);
                        % ��� ������� ������������ ��-� ��� 112.
                        obj.dofPerNode = 2;
                        nodeNums = obj.allMeshElems(i).GetNodesNums;
                        GD1 = (nodeNums(1)-1)*(obj.dofPerNode)+1;
                        GD2 = GD1+1;
                        GD3 = (nodeNums(2)-1)*(obj.dofPerNode)+1;
                        GD4 = GD3+1;
                        obj.iM(i,1) = GD1;
                        obj.iM(i,2) = GD2;
                        obj.iM(i,3) = GD3;
                        obj.iM(i,4) = GD4;
                        % �������� (����������) ������ � ��������� �������
                        % ������������ iMnod. �� ����������.
                        % ������������� ��������. ���� ����������.
                        obj.iMnod(nodeNums(1),1) = GD1;
                        obj.iMnod(nodeNums(1),2) = GD2;
                        obj.iMnod(nodeNums(2),1) = GD3;
                        obj.iMnod(nodeNums(2),2) = GD4;
                    otherwise
                        disp('FEMesh: Unknown element type.');
                end
            end
        end
        % ����������� 2D ����� �� �������.
        function Plot2DMesh(this)
            labels = cellstr(num2str([1:this.numberOfNodes]'));
            plot(this.allNodes(:,1),this.allNodes(:,2), 'bo',...
                'MarkerSize',8,'MarkerFaceColor', 'w',...
                'LineWidth', 2.0);
            % ���� �� �������:
            nodesSpanX = max(this.allNodes(:,1))-min(this.allNodes(:,1));
            nodesSpanY = max(this.allNodes(:,2))-min(this.allNodes(:,2));
            % ���� �� ��� �������� � ���.
            if (nodesSpanX~=0 && nodesSpanY~=0)
                xlim([(-1)*((nodesSpanX)/10) ...
                    max(this.allNodes(:,1))+(nodesSpanX)/10]);
                ylim([(-1)*((nodesSpanY)/10) ...
                    max(this.allNodes(:,2))+(nodesSpanY)/10]);
            end
            % ������ �����.
            text(this.allNodes(:,1),this.allNodes(:,2), labels,...
                'LineWidth',2,'VerticalAlignment', 'bottom',...
                'HorizontalAlignment','right');
            % ������ ���������.
            hold on;
            grid on;
            for el = 1:this.numberOfElems
                % ����������� ��������� ����� �������� ��������.
                currElem = this.allMeshElems(el);
                currNodalCoords = currElem.GetNodalCoords();
                % ������ �����.
                plot([currNodalCoords(1,1) currNodalCoords(2,1)],...
                    [currNodalCoords(1,2) currNodalCoords(2,2)]);
                % ����������� ��������� ������ ����������� ��������.
                dx = currNodalCoords(1,1) - currNodalCoords(2,1);
                dy = currNodalCoords(1,2) - currNodalCoords(2,2);
                textCoord1 = currNodalCoords(1,1)-(dx/2);
                textCoord2 = currNodalCoords(1,2)-(dy/2);
                % �������� �� ������ ����������� ��������
                text(textCoord1,textCoord2,num2str(el));
            end
            hold off;
        end
        % ������ ������� ������������.
        function DispIM(this)
            format shortG;
            disp('DOF distribution matrix:');
            disp(this.iM);
            format compact;
        end
        % ������ ����� �� ��������� �����.
        function DispNN(this)
            format shortG;
            disp('Nodes:');
            for i=1:this.numberOfElems
                nn = this.allMeshElems(i).GetNodesNums();
                disp(nn);
            end
            format compact;
        end
    end
end

