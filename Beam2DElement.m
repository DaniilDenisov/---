% ����� ��������� �������� ������� ����.
% Copyright 2017 Daniil S. Denisov
classdef Beam2DElement < FiniteElementStructural
    methods (Access = public)
        % ���������� ������������ ������ ���������������.
        function [GK, GM] = Assembler(this, GK, GM, IM, elNum)
%             % ���������� ���������� �� � ��.
%             K = StiffnessElementMatrix(this);
%             M = MassElementMatrix(this);
%             % �����. ����. �������� ��� ���������� �������� �������.
%             glDOF1 = IM(elNum,1);
%             glDOF2 = IM(elNum,2);
%             glDOF3 = IM(elNum,3);
%             glDOF4 = IM(elNum,4);
%             % ��������������� ��������� ke � ����. ������� GK.
%             GK(glDOF1,glDOF1) = GK(glDOF1,glDOF1) + K(1,1);
%             GK(glDOF1,glDOF2) = GK(glDOF1,glDOF2) + K(1,2);
%             GK(glDOF1,glDOF3) = GK(glDOF1,glDOF3) + K(1,3);
%             GK(glDOF1,glDOF4) = GK(glDOF1,glDOF4) + K(1,4);
%             GK(glDOF2,glDOF1) = GK(glDOF2,glDOF1) + K(2,1);
%             GK(glDOF2,glDOF2) = GK(glDOF2,glDOF2) + K(2,2);
%             GK(glDOF2,glDOF3) = GK(glDOF2,glDOF3) + K(2,3);
%             GK(glDOF2,glDOF4) = GK(glDOF2,glDOF4) + K(2,4);
%             GK(glDOF3,glDOF1) = GK(glDOF3,glDOF1) + K(3,1);
%             GK(glDOF3,glDOF2) = GK(glDOF3,glDOF2) + K(3,2);
%             GK(glDOF3,glDOF3) = GK(glDOF3,glDOF3) + K(3,3);
%             GK(glDOF3,glDOF4) = GK(glDOF3,glDOF4) + K(3,4);
%             GK(glDOF4,glDOF1) = GK(glDOF4,glDOF1) + K(4,1);
%             GK(glDOF4,glDOF2) = GK(glDOF4,glDOF2) + K(4,2);
%             GK(glDOF4,glDOF3) = GK(glDOF4,glDOF3) + K(4,3);
%             GK(glDOF4,glDOF4) = GK(glDOF4,glDOF4) + K(4,4);
%             % ��������������� ������� ��������� � ���������� GM.
%             GM(glDOF1,glDOF1) = GM(glDOF1,glDOF1) + M(1,1);
%             GM(glDOF1,glDOF2) = GM(glDOF1,glDOF2) + M(1,2);
%             GM(glDOF1,glDOF3) = GM(glDOF1,glDOF3) + M(1,3);
%             GM(glDOF1,glDOF4) = GM(glDOF1,glDOF4) + M(1,4);
%             GM(glDOF2,glDOF1) = GM(glDOF2,glDOF1) + M(2,1);
%             GM(glDOF2,glDOF2) = GM(glDOF2,glDOF2) + M(2,2);
%             GM(glDOF2,glDOF3) = GM(glDOF2,glDOF3) + M(2,3);
%             GM(glDOF2,glDOF4) = GM(glDOF2,glDOF4) + M(2,4);
%             GM(glDOF3,glDOF1) = GM(glDOF3,glDOF1) + M(3,1);
%             GM(glDOF3,glDOF2) = GM(glDOF3,glDOF2) + M(3,2);
%             GM(glDOF3,glDOF3) = GM(glDOF3,glDOF3) + M(3,3);
%             GM(glDOF3,glDOF4) = GM(glDOF3,glDOF4) + M(3,4);
%             GM(glDOF4,glDOF1) = GM(glDOF4,glDOF1) + M(4,1);
%             GM(glDOF4,glDOF2) = GM(glDOF4,glDOF2) + M(4,2);
%             GM(glDOF4,glDOF3) = GM(glDOF4,glDOF3) + M(4,3);
%             GM(glDOF4,glDOF4) = GM(glDOF4,glDOF4) + M(4,4);
        end
        % ����������� ������ ��� ����������.
        function obj = Beam2DElement()
        end
        % ������� ��������� �����.
        function SetupElement(this,nodCoordsIn,...
                nodesNumsIn ,dataIn)
            % ��������� ���� �������� ��� ������������.
            this.elType = 112;
            this.elNodesCoords = nodCoordsIn;
            this.elData = dataIn;
            this.elNodesNums = nodesNumsIn;
        end
        % ������� ������.
        function Disp(this)
            format shortG;
            fprintf('type:%d\n',this.elType);
            disp(this.elNodesCoords);
            disp(this.elNodesNums);
            disp(this.elData);
            format compact;
        end
    end
    methods (Access = protected)
        % ������� ����������� ������� ���� ��������.
        function M = MassElementMatrix(this)
%             % ��������� �� "���� ������" ������������� ��������.
%             currArea = this.elData(1);
%             currRho = this.elData(3);
%             % ����� ������� ����������� ������� ��������� � �����.
%             [T, length] = TransformMatrix(this);
%             % ������� ���� �������� ��� �������������� ���������.
%             meInit = (currRho*currArea*length/6)*...
%                 [2 0 1 0; 0 2 0 1; 1 0 2 0; 0 1 0 2];
%             % �������������� ������� ����.
%             M = T'*meInit*T;
        end
        % ������� ����������� ������� ��������� ��������.
        function K = StiffnessElementMatrix(this)
%             % ��������� �� "���� ������" ������������� ��������.
%             currArea = this.elData(1);
%             currEmod = this.elData(2);
%             % ����� ������� ����������� ������� ��������� � �����.
%             [T, length] = TransformMatrix(this);
%             % ������� ��������� �������� ��� �������������� ���������.
%             KInit = zeros(4,4);
%             kCoeff = currArea*currEmod/length;
%             KInit(1,1) = kCoeff;
%             KInit(1,3) = -kCoeff;
%             KInit(3,1) = -kCoeff;
%             KInit(3,3) = kCoeff;
%             % �������������� ���������� ������� ���������.
%             K = T'*KInit*T;
        end
        % ������� ����������� ������� ��������� � ����� ��������.
        function [T, length] = TransformMatrix(this)
            node1 = this.elNodesCoords(1,:);
            node2 = this.elNodesCoords(2,:);
            dx = node2(1,1)-node1(1,1);
            dy = node2(1,2)-node1(1,2);
            length = sqrt(dx^2 + dy^2);
            c = dx/length;
            s = dy/length;
            T = [c s 0 0;-s c 0 0;0 0 c s;0 0 -s c];
        end
    end
end