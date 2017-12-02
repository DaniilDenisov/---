%Copyright 2017 Daniil S. Denisov
function [ sigma ] = StressCalc( nElems,allElems,allNodes,...
    displ, dofPerNode)
%UNTITLED ������� ��������� ���������� � �������� �����.
% Copyright 2017 Daniil S. Denisov

sigma = zeros(nElems,1);
for i=1:nElems
    % ����� �������� ��������, ��� ����� � ������ ���� �� allElems.
    currElem = allElems(i,:);
    currNode1 = allNodes(currElem(1),:);
    currNode2 = allNodes(currElem(2),:);
    currEmod = currElem(4);
    % ���������� ������� ��� ���������� �������� �������.
    glDOF1 = (currElem(1)-1)*dofPerNode+1;
    glDOF2 = glDOF1+1;
    glDOF3 = (currElem(2)-1)*dofPerNode+1;
    glDOF4 = glDOF3+1;
    % ����� �� �� ������� ��� ���������� ���������� ��-�� i.
    currDispl = [displ(glDOF1),displ(glDOF2),displ(glDOF3),...
        displ(glDOF4)];
    % ����������� ������������ ��������� (c, s).
    [~,length,c,s] = ElemTransformCalc(currNode1, currNode2);
    % ����� ���� (���������� ���������� � i-� �������):
    sigma(i) = (currEmod/length)*[-c -s c s]*currDispl';
end