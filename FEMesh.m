% ����� �� �����.
% Copyright 2017 Daniil S. Denisov
classdef FEMesh < handle
    properties (Access = public)
        % ����� ���������.
        numberOfElems=0;
        % ����� �����.
        numberOfNodes=0;
        % ����� �� � ����������� �����.
        numberOfForceBCs=0;
        % ����� �� �������.
        numberOfFixBCs=0;
        % ����� �������� ������� �� ���� ����.
        dofPerNode;
        % ��������� ������� ������������.
        iMnod;
        % ������ ��������� (���������������� �����).
        allMeshElems;
        % ������ �����.
        allNodes;
        % ������ �� �������.
        allFixBCs;
        % ������ �� ����������� ���.
        allForceBCs;
    end
    methods
        % ������ ����� ����� (�����������).
        function obj = FEMesh(filename)
            % �������� ����������� �����. -1 ���� ����� ���.
            fid = fopen(filename,'r');
            % ����. ����� ������ = 10.
            for bn=1:10
                % ������ ������.
                line = fgetl(fid);
                % ������ ������ ������ ���� ��������. ������� �� ���� �������.
                switch line
                    case 'nodes'
                        obj.readNodes(fid);
                    case 'elems_112'
                        obj.readElems112(fid);
                    case 'elems_113'
                        obj.readElems113(fid);
                    case 'bcforce_stat'
                        obj.readBcForcesStat(fid);
                    case 'bcforce_harm'
                        obj.readBcForcesHarm(fid);
                    case 'bcfix'
                        obj.readBcFix(fid);
                    case -1
                        break
                    otherwise
                        warning('Unexpected line marker in task file.');
                end
            end
            % �������� �����.
            fclose(fid);
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
            disp(this.iMnod);
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
        % ������ ���������.
        function DispElems(this)
            for i=1:this.numberOfElems
               this.allMeshElems(i).Disp();
            end
        end
        
        % -------------------- ����� ������ (������) --------------------
        % ������ ����� ������ �� �����.
        function readNodes(this,fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            nNum = sscanf(line,'%d');
            this.numberOfNodes = nNum;
            % ������ ����� � ���������� ���� �����.
            for i=1:nNum
                this.allNodes(i,:) = sscanf(fgetl(fid),'%f,%f,%f');
            end
        end
        
        % ������ ����� ������ �� ��������� 112.
        % ��������! ������ ����� ������ ���� ��������.
        function readElems112(this, fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            elNum = sscanf(line,'%d');
            this.numberOfElems = elNum;
            % ������������ ������ ������ �� ���� 112 (Truss2DElement).
            elemArrTmp(elNum,1) = Truss2DElement();
            this.allMeshElems = elemArrTmp;
            % ��� �������� 112 ������ ���� 2 �� � ����.
            this.dofPerNode = 2;
            % ����� - ������. � ������������ � ��������.
            for i=1:elNum
                line = fgetl(fid);
                splitElemLine = strsplit(line,',');
                % ������ ���� �������� ���������, �.�. ����������� �������.
                % ������ �� ������ �������. ������ �����.
                elNodes = str2double(splitElemLine(2:3));
                elData = str2double(splitElemLine(4:6));
                elNode1Coords = this.allNodes(elNodes(1),:);
                elNode2Coords = this.allNodes(elNodes(2),:);
                this.allMeshElems(i).SetupElement(...
                            [elNode1Coords; elNode2Coords],...
                            elNodes, ...
                            elData);
            end
            % ����� ������� ������� ������������, �.�. ���� dofPerNode.
            for i=1:this.numberOfNodes
                this.iMnod(i,:) = [(i*this.dofPerNode)-1 i*this.dofPerNode];
            end
        end
        
        % ������ ����� ������ �� ��������� 113 (����� 2 ���� �� 3 ��).
        % ��������! ������ ����� ������ ���� ��������.
        function readElems113(this, fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            elNum = sscanf(line,'%d');
            this.numberOfElems = elNum;
            % ������������ ������ ������ �� ���� 112 (Truss2DElement).
            elemArrTmp(elNum,1) = Beam2DElement();
            this.allMeshElems = elemArrTmp;
            % ��� �������� 113 ������ ���� 3 �� � ����.
            this.dofPerNode = 3;
            % ����� - ������. � ������������ � ��������.
            for i=1:elNum
                line = fgetl(fid);
                splitElemLine = strsplit(line,',');
                % ������ ���� �������� ���������, �.�. ����������� �������.
                % ������ �� ������ �������. ������ �����.
                elNodes = str2double(splitElemLine(2:3));
                % ������ �������� ����� (�������, ���. ����, ���������,
                % ������ �������)
                elData = str2double(splitElemLine(4:7));
                elNode1Coords = this.allNodes(elNodes(1),:);
                elNode2Coords = this.allNodes(elNodes(2),:);
                this.allMeshElems(i).SetupElement(...
                            [elNode1Coords; elNode2Coords],...
                            elNodes, ...
                            elData);
            end
            % ����� ������� ������� ������������, �.�. ���� dofPerNode.
            for i=1:this.numberOfNodes
                this.iMnod(i,:) = [(i*this.dofPerNode)-2 ...
                                   (i*this.dofPerNode)-1 ...
                                   (i*this.dofPerNode)];
            end
        end
        
        % ������ ����� ������ � ��������� �������� �������.
        function readBcFix(this, fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            bcFixNum = sscanf(line,'%d');
            this.numberOfFixBCs = this.numberOfFixBCs + bcFixNum;
            % ������ ����� � ���������� ���� �����.
            for i=1:bcFixNum
                this.allFixBCs(i,:) = sscanf(fgetl(fid),...
                    '%f,%f,%f,%f,%f');
            end
        end
        % ������ ����� ������ � �� ������. ��� (����./����).
        function readBcForcesStat(this, fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            bcForceNum = sscanf(line,'%d');
            this.numberOfForceBCs = this.numberOfForceBCs + bcForceNum;
            % ������ ����� � ���������� ���� �����.
            for i=1:bcForceNum
                this.allForceBCs(i,:) = sscanf(fgetl(fid),...
                    '%f,%f,%f,%f,%f');
            end
        end
        % ������ ����� ������ � �� ����������� ��� (�������������).
        function readBcForcesHarm(this, fid)
            % � ������ ����� ������ ���� ������.
            line = fgetl(fid);
            bcForceNum = sscanf(line,'%d');
            this.numberOfForceBCs = this.numberOfForceBCs + bcForceNum;
            % ������ ����� � ���������� ���� �����.
            for i=1:bcForceNum
                this.allForceBCs(i,:) = sscanf(fgetl(fid),...
                    '%f,%f,%f,%f,%f,%f');
            end
        end
    end
end

