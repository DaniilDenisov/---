% ����� ��������� �������� ������� ���� (��� 113).
% Copyright 2017 Daniil S. Denisov
classdef Beam2DElement < FiniteElementStructural
    methods (Access = public)
        % ���������� ������������ ������ ���������������.
        function [GK, GM] = Assembler(this, GK, GM, IM)
            % ���������� ���������� �� � ��.
            K = StiffnessElementMatrix(this);
            M = MassElementMatrix(this);
            
            % �����. ����. �������� ��� ���������� �������� �������.
            glDOF1 = IM(this.elNodesNums(1),1);
            glDOF2 = IM(this.elNodesNums(1),2);
            glDOF3 = IM(this.elNodesNums(1),3);
            glDOF4 = IM(this.elNodesNums(2),1);
            glDOF5 = IM(this.elNodesNums(2),2);
            glDOF6 = IM(this.elNodesNums(2),3);
            
            % ��������������� ��������� ke � ����. ������� GK.
            GK(glDOF1,glDOF1) = GK(glDOF1,glDOF1) + K(1,1);
            GK(glDOF1,glDOF2) = GK(glDOF1,glDOF2) + K(1,2);
            GK(glDOF1,glDOF3) = GK(glDOF1,glDOF3) + K(1,3);
            GK(glDOF1,glDOF4) = GK(glDOF1,glDOF4) + K(1,4);
            GK(glDOF1,glDOF5) = GK(glDOF1,glDOF5) + K(1,5);
            GK(glDOF1,glDOF6) = GK(glDOF1,glDOF6) + K(1,6);
            
            GK(glDOF2,glDOF1) = GK(glDOF2,glDOF1) + K(2,1);
            GK(glDOF2,glDOF2) = GK(glDOF2,glDOF2) + K(2,2);
            GK(glDOF2,glDOF3) = GK(glDOF2,glDOF3) + K(2,3);
            GK(glDOF2,glDOF4) = GK(glDOF2,glDOF4) + K(2,4);
            GK(glDOF2,glDOF5) = GK(glDOF2,glDOF5) + K(2,5);
            GK(glDOF2,glDOF6) = GK(glDOF2,glDOF6) + K(2,6);
            
            GK(glDOF3,glDOF1) = GK(glDOF3,glDOF1) + K(3,1);
            GK(glDOF3,glDOF2) = GK(glDOF3,glDOF2) + K(3,2);
            GK(glDOF3,glDOF3) = GK(glDOF3,glDOF3) + K(3,3);
            GK(glDOF3,glDOF4) = GK(glDOF3,glDOF4) + K(3,4);
            GK(glDOF3,glDOF5) = GK(glDOF3,glDOF5) + K(3,5);
            GK(glDOF3,glDOF6) = GK(glDOF3,glDOF6) + K(3,6);
            
            GK(glDOF4,glDOF1) = GK(glDOF4,glDOF1) + K(4,1);
            GK(glDOF4,glDOF2) = GK(glDOF4,glDOF2) + K(4,2);
            GK(glDOF4,glDOF3) = GK(glDOF4,glDOF3) + K(4,3);
            GK(glDOF4,glDOF4) = GK(glDOF4,glDOF4) + K(4,4);
            GK(glDOF4,glDOF5) = GK(glDOF4,glDOF5) + K(4,5);
            GK(glDOF4,glDOF6) = GK(glDOF4,glDOF6) + K(4,6);
            
            GK(glDOF5,glDOF1) = GK(glDOF5,glDOF1) + K(5,1);
            GK(glDOF5,glDOF2) = GK(glDOF5,glDOF2) + K(5,2);
            GK(glDOF5,glDOF3) = GK(glDOF5,glDOF3) + K(5,3);
            GK(glDOF5,glDOF4) = GK(glDOF5,glDOF4) + K(5,4);
            GK(glDOF5,glDOF5) = GK(glDOF5,glDOF5) + K(5,5);
            GK(glDOF5,glDOF6) = GK(glDOF5,glDOF6) + K(5,6);
            
            GK(glDOF6,glDOF1) = GK(glDOF6,glDOF1) + K(6,1);
            GK(glDOF6,glDOF2) = GK(glDOF6,glDOF2) + K(6,2);
            GK(glDOF6,glDOF3) = GK(glDOF6,glDOF3) + K(6,3);
            GK(glDOF6,glDOF4) = GK(glDOF6,glDOF4) + K(6,4);
            GK(glDOF6,glDOF5) = GK(glDOF6,glDOF5) + K(6,5);
            GK(glDOF6,glDOF6) = GK(glDOF6,glDOF6) + K(6,6);
            
            % ��������������� ������� ���� � ���������� GM.
            GM(glDOF1,glDOF1) = GM(glDOF1,glDOF1) + M(1,1);
            GM(glDOF1,glDOF2) = GM(glDOF1,glDOF2) + M(1,2);
            GM(glDOF1,glDOF3) = GM(glDOF1,glDOF3) + M(1,3);
            GM(glDOF1,glDOF4) = GM(glDOF1,glDOF4) + M(1,4);
            GM(glDOF1,glDOF5) = GM(glDOF1,glDOF5) + M(1,5);
            GM(glDOF1,glDOF6) = GM(glDOF1,glDOF6) + M(1,6);
            
            GM(glDOF2,glDOF1) = GM(glDOF2,glDOF1) + M(2,1);
            GM(glDOF2,glDOF2) = GM(glDOF2,glDOF2) + M(2,2);
            GM(glDOF2,glDOF3) = GM(glDOF2,glDOF3) + M(2,3);
            GM(glDOF2,glDOF4) = GM(glDOF2,glDOF4) + M(2,4);
            GM(glDOF2,glDOF5) = GM(glDOF2,glDOF5) + M(2,5);
            GM(glDOF2,glDOF6) = GM(glDOF2,glDOF6) + M(2,6);
            
            GM(glDOF3,glDOF1) = GM(glDOF3,glDOF1) + M(3,1);
            GM(glDOF3,glDOF2) = GM(glDOF3,glDOF2) + M(3,2);
            GM(glDOF3,glDOF3) = GM(glDOF3,glDOF3) + M(3,3);
            GM(glDOF3,glDOF4) = GM(glDOF3,glDOF4) + M(3,4);
            GM(glDOF3,glDOF5) = GM(glDOF3,glDOF5) + M(3,5);
            GM(glDOF3,glDOF6) = GM(glDOF3,glDOF6) + M(3,6);
            
            GM(glDOF4,glDOF1) = GM(glDOF4,glDOF1) + M(4,1);
            GM(glDOF4,glDOF2) = GM(glDOF4,glDOF2) + M(4,2);
            GM(glDOF4,glDOF3) = GM(glDOF4,glDOF3) + M(4,3);
            GM(glDOF4,glDOF4) = GM(glDOF4,glDOF4) + M(4,4);
            GM(glDOF4,glDOF5) = GM(glDOF4,glDOF5) + M(4,5);
            GM(glDOF4,glDOF6) = GM(glDOF4,glDOF6) + M(4,6);
            
            GM(glDOF5,glDOF1) = GM(glDOF5,glDOF1) + M(5,1);
            GM(glDOF5,glDOF2) = GM(glDOF5,glDOF2) + M(5,2);
            GM(glDOF5,glDOF3) = GM(glDOF5,glDOF3) + M(5,3);
            GM(glDOF5,glDOF4) = GM(glDOF5,glDOF4) + M(5,4);
            GM(glDOF5,glDOF5) = GM(glDOF5,glDOF5) + M(5,5);
            GM(glDOF5,glDOF6) = GM(glDOF5,glDOF6) + M(5,6);
            
            GM(glDOF6,glDOF1) = GM(glDOF6,glDOF1) + M(6,1);
            GM(glDOF6,glDOF2) = GM(glDOF6,glDOF2) + M(6,2);
            GM(glDOF6,glDOF3) = GM(glDOF6,glDOF3) + M(6,3);
            GM(glDOF6,glDOF4) = GM(glDOF6,glDOF4) + M(6,4);
            GM(glDOF6,glDOF5) = GM(glDOF6,glDOF5) + M(6,5);
            GM(glDOF6,glDOF6) = GM(glDOF6,glDOF6) + M(6,6);
        end
        % ����������� ������ ��� ����������.
        function obj = Beam2DElement()
        end
        % ������� ��������� �����.
        function SetupElement(this,nodCoordsIn,...
                nodesNumsIn ,dataIn)
            % ��������� ���� �������� ��� ������������.
            this.elType = 113;
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
            % ��������� �� "���� ������" ������������� ��������.
            A = this.elData(1);   % �������.
            Rho = this.elData(3); % ���������.
            % �������� ����� (������� ����� / unit length).
            Mul = Rho*A;
            % ����� ������� ����������� ������� ��������� � �����.
            [T, L] = TransformMatrix(this);
            % ������� ���� �������� ��� �������������� ���������.
            meInit = zeros(6,6);
            meInit(1,:) = (Mul*L/420)*[140 0 0 70 0 0];
            meInit(2,:) = (Mul*L/420)*[0 156 22*L 0 54 -13*L];
            meInit(3,:) = (Mul*L/420)*[0 22*L 4*L*L 0 13*L -3*L*L];
            meInit(4,:) = (Mul*L/420)*[70 0 0 140 0 0];
            meInit(5,:) = (Mul*L/420)*[0 54 13*L 0 156 0];
            meInit(6,:) = (Mul*L/420)*[0 -13*L -3*L*L 0 -22*L 4*L*L];
            % �������������� ������� ����.
            M = T'*meInit*T;
        end
        % ������� ����������� ������� ��������� ��������.
        function K = StiffnessElementMatrix(this)
            % ��������� �� "���� ������" ������������� ��������.
            A = this.elData(1); % �������.
            E = this.elData(2); % ������ ����.
            I = this.elData(4); % ������ �������.
            % ����� ������� ����������� ������� ��������� � �����.
            [T, L] = TransformMatrix(this);
            % ������� ��������� �������� ��� �������������� ���������.
            KInit = zeros(6,6);
            KInit(1,:) = (E*I/(L*L*L))*[A*L*L/I 0 0 -A*L*L/I 0 0];
            KInit(2,:) = (E*I/(L*L*L))*[0 12 6*L 0 -12 6*L];
            KInit(3,:) = (E*I/(L*L*L))*[0 6*L 4*L*L 0 -6*L 2*L*L];
            KInit(4,:) = (E*I/(L*L*L))*[-A*L*L/I 0 0 A*L*L/I 0 0];
            KInit(5,:) = (E*I/(L*L*L))*[0 -12 -6*L 0 12 -6*L];
            KInit(6,:) = (E*I/(L*L*L))*[0 6*L 2*L*L 0 -6*L 4*L*L];
            % �������������� ���������� ������� ���������.
            K = T'*KInit*T;
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
            T = [c s 0 0 0 0;...
                -s c 0 0 0 0;...
                 0 0 1 0 0 0;...
                 0 0 0 c s 0;...
                0 0 0 -s c 0;...
                 0 0 0 0 0 1];
        end
    end
end