% ����������� ����� ������������ ��.
classdef (Abstract) FiniteElementStructural < handle
    properties (Access = public)
        % ��� ��������.
        elType;
    end
    properties (Access = protected)
        % ���������� �����.
        elNodesCoords;
        % ������ �����.
        elNodesNums;
        % ������ �������� (���������, �������).
        elData;
    end
    methods (Access = public)
        % ����������� ��� ����������.
        function obj = FiniteElementStructural()
        end
        % ������� ��������� ���� ������� ��������� (��� ������ �����).
        function nCoords = GetNodalCoords(this)
            nCoords = this.elNodesCoords;
        end
        % ������� ��������� ������� ����� �������� (��� ���������� �������
        % ������������).
        function nNums = GetNodesNums(this)
            nNums = this.elNodesNums;
        end
    end
    methods (Access = public, Abstract = true)
        % ��������� ��-�� � ����. ������� M � K �� ������� ������������ IM.
        [GM, GK] = Assembler(GM, GK, IM, elNum)
    end
    methods (Access = protected, Abstract = true)
        % ���������� ������ ����� � ���������.
        M = MassElementMatrix(this)
        K = StiffnessElementMatrix(this)
    end
end