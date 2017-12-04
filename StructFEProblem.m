% ����� ������.
% Copyright 2017 Daniil S. Denisov
classdef StructFEProblem < handle
    properties (Access = public)
        % ��� ����-�����.
        filename
        % ������� ���������.
        K
        % ������� ����.
        M
        % ������ ������ �����.
        F
        % ����� � ��.
        mesh
    end
    methods
        % ����������� � ����������.
        function obj = StructFEProblem(filename)
            obj.filename = filename;
            % ������ �����, �������� �����.
            obj.mesh = FEMesh(obj.filename);
            % ����� ����� �� ������.
            obj.mesh.Plot2DMesh();
            % ������ ������� ����� � ���������.
            obj.mesh.DispNN();
            % ������ ������� ������������.
            obj.mesh.DispIM();
            % �������� ���������� ������� ���������, ������� F � �������
            % ���� � ����������� �� ���� ��������.
            elType = obj.mesh.allMeshElems(1).elType;
            switch elType
                % ������� ��� 112:
                case 112
                    % �������� ������� � ����.
                    dofPerNode = 2;
                    % ����������� ������ ����� �������� ������� � �������
                    % � ����. ���������� ������� ���������.
                    systemDOF = obj.mesh.numberOfNodes*dofPerNode;
                    GlobK = zeros(systemDOF,systemDOF);
                    GlobM = zeros(systemDOF,systemDOF);
                    % ����� ���� ��������� � �����.
                    for i=1:obj.mesh.numberOfElems
                        % ��������������� � ���������� �������.
                        [GlobK,GlobM] = ...
                            obj.mesh.allMeshElems(i).Assembler(GlobK,...
                            GlobM, obj.mesh.iM, i);
                    end
                    obj.K = GlobK;
                    obj.M = GlobM;
                    % ������ ������ ����� (���). ������������ ��� ��.
                    obj.F = zeros(obj.mesh.numberOfNodes*dofPerNode,1);
                % ������� ��� 113.
                case 113
                    % �������� ������� � ����.
                    dofPerNode = 3;
                    % ����������� ������ ����� �������� ������� � �������
                    % � ����. ���������� ������� ���������.
                    systemDOF = obj.mesh.numberOfNodes*dofPerNode;
                    GlobK = zeros(systemDOF,systemDOF);
                    GlobM = zeros(systemDOF,systemDOF);
                    % ����� ���� ��������� � �����.
                    for i=1:obj.mesh.numberOfElems
                        % ��������������� � ���������� �������.
                        [GlobK,GlobM] = ...
                            obj.mesh.allMeshElems(i).Assembler(GlobK,...
                            GlobM, obj.mesh.iM, i);
                    end
                    obj.K = GlobK;
                    obj.M = GlobM;
                    % ������ ������ ����� (���). ������������ ��� ��.
                    obj.F = zeros(obj.mesh.numberOfNodes*dofPerNode,1);
                otherwise
                    disp('SructFEProblem(filename): bad element type!');
            end
            
        end
        % ����� ��������� ��. ��� ������� ��� ������� ����.
        function ApplyBC(this)
            BC = this.mesh.allBCs;
            BCtotal = this.mesh.numberOfBCs;
            for i=1:BCtotal
                % ����� ��
                currBC = BC(i,:);
                % ����� ��� ��.
                typeBC = currBC(1);
                % ����� ����� ����.
                nnumBC = currBC(2);
                % ��������� ������ �������� ������� � ����. ��, MM, ���.
                GLDOFs = this.mesh.iMnod(nnumBC,:);
                % ��������� �� � ��.
                % ������� ���� ��. �������� ������, ������� � �������� 1 ��
                % ���������.
                if (typeBC==1)
                    for n=1:size(GLDOFs,1)
                        this.K(GLDOFs(n),:) = 0;
                        this.K(:,GLDOFs(n)) = 0;
                        this.K(GLDOFs(n),GLDOFs(n)) = 1;
                    end
                end
                % ������� ������. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==2)
                    this.K(GLDOFs(2),:) = 0;
                    this.K(:,GLDOFs(2)) = 0;
                    this.K(GLDOFs(2),GLDOFs(2)) = 1;
                end
                % ������� ���. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==3)
                    this.K(GLDOFs(1),:) = 0;
                    this.K(:,GLDOFs(1)) = 0;
                    this.K(GLDOFs(1),GLDOFs(1)) = 1;
                end
                % ���� ����, �� ���������� �������� � ������ ������ �����.
                if (typeBC==10)
                    % ����� �������� ���� �� ����������� �� BC.
                    forceValue = zeros(3,1);
                    forceValue(1) = currBC(1,3);
                    forceValue(2) = currBC(1,4);
                    forceValue(3) = currBC(1,5);
                    % ���������� � ������ ��. �����.
                    for n=1:size(GLDOFs,1)
                        this.F(GLDOFs(1)) = this.F(GLDOFs(1))+forceValue(1);
                        this.F(GLDOFs(2)) = this.F(GLDOFs(2))+forceValue(2);
                    end
                end
            end
        end
        % ����� ��������� �� ��� �������� ����������� ���������. ��� ���.
        function ApplyBCEig(this)
            BC = this.mesh.allBCs;
            BCtotal = this.mesh.numberOfBCs;
            for i=1:BCtotal
                % ����� ��
                currBC = BC(i,:);
                % ����� ��� ��.
                typeBC = currBC(1);
                % ����� ����� ����.
                nnumBC = currBC(2);
                % ��������� ����� ������� ������� � ����. ��, MM, ���.
                GLDOFs = this.mesh.iMnod(nnumBC,:);
                glDOF1=GLDOFs(1);
                glDOF2=GLDOFs(2);
                % ��������� �� � ��.
                % ������� ����� ��. �������� ������, ������� � �������� 1 �� ���������.
                % �.�. � ���� ��� ��, �� ���������� 2 ������ � 2 �������.
                if (typeBC==1)
                    this.M(glDOF1,:) = 0;
                    this.M(:,glDOF1) = 0;
                    this.M(glDOF2,:) = 0;
                    this.M(:,glDOF2) = 0;
                    this.M(glDOF1,glDOF1) = 1;
                    this.M(glDOF2,glDOF2) = 1;
                    this.K(glDOF1,:) = 0;
                    this.K(:,glDOF1) = 0;
                    this.K(glDOF2,:) = 0;
                    this.K(:,glDOF2) = 0;
                end
                % ������� ������. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==2)
                    this.M(glDOF2,:) = 0;
                    this.M(:,glDOF2) = 0;
                    this.M(glDOF2,glDOF2) = 1;
                    this.K(glDOF2,:) = 0;
                    this.K(:,glDOF2) = 0;
                end
                % ������� ���. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==3)
                    this.M(glDOF1,:) = 0;
                    this.M(:,glDOF1) = 0;
                    this.M(glDOF1,glDOF1) = 1;
                    this.K(glDOF1,:) = 0;
                    this.K(:,glDOF1) = 0;
                end
            end
        end
        % ����� ��������� �� ��� ������������� ������� (Transient).
        function ApplyBCTrt(this,tStep,tsNum)
            % this  - ������ ��� ������ � ������ (������� ��������),
            % tStep - ��� �� �������,
            % tsNum - ���������� ��������� �����.
            % ����������� � ��������� ���������� ����� ����� � �� �� ����.
            nn = this.mesh.numberOfNodes;
            dpn = this.mesh.dofPerNode;
            % ������������� ������� ������ ����� ��� ������������� �������.
            % ������� - ��� �� �������.
            this.F = zeros(nn*dpn,tsNum);
            % ��������� �����������.
            allBCs = this.mesh.allBCs;
            for bc=1:this.mesh.numberOfBCs
                % ����� ��
                currBC = allBCs(bc,:);
                % ����� ��� ��.
                typeBC = currBC(1);
                % ����� ����� ����.
                nnumBC = currBC(2);
                % ��������� ����� ������� ������� � ����. ��, MM, ���.
                GLDOFs = this.mesh.iMnod(nnumBC,:);
                glDOF1=GLDOFs(1);
                glDOF2=GLDOFs(2);
                % ��������� �� ��������� �����.
                % �� ����������� �� ����.
                % ������� ����� ��. �������� ������, ������� � �������� 1 �� ���������.
                % �.�. � ���� ��� ��, �� ���������� 2 ������ � 2 �������.
                if (typeBC==1)
                    this.K(glDOF1,:) = 0;
                    this.K(:,glDOF1) = 0;
                    this.K(glDOF2,:) = 0;
                    this.K(:,glDOF2) = 0;
                    this.K(glDOF1,glDOF1) = 1;
                    this.K(glDOF2,glDOF2) = 1;
                end
                % ������� ������. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==2)
                    this.K(glDOF2,:) = 0;
                    this.K(:,glDOF2) = 0;
                    this.K(glDOF2,glDOF2) = 1;
                end
                % ������� ���. ��, �������� ���� (�� ������ ��) �������.
                if (typeBC==3)
                    this.K(glDOF1,:) = 0;
                    this.K(:,glDOF1) = 0;
                    this.K(glDOF1,glDOF1) = 1;
                end
                % ���� ����, �� ���������� �������� � ������ ������ �����
                % �� ������ ���� �� ������� (������ �������).
                if (typeBC==10)
                    % ����� �������� ���� �� ����������� �� BC.
                    forceValue = zeros(3,1);
                    forceValue(1) = currBC(1,3);
                    forceValue(2) = currBC(1,4);
                    forceValue(3) = currBC(1,5);
                    % ���������� � ������ ��. �����.
                    this.F(glDOF1,:) = this.F(glDOF1,:)+forceValue(1);
                    this.F(glDOF2,:) = this.F(glDOF2,:)+forceValue(2);
                end
                % ���� �������������� ���� �������������, ������� tsNum
                % �������� � ����������� ���������� ���.
                if typeBC==11
                    forceValue = zeros(3,1);
                    % ������� Fx,Fy,Fz � forceValue.
                    forceValue(1) = currBC(1,3);
                    forceValue(2) = currBC(1,4);
                    forceValue(3) = currBC(1,5);
                    % ������� ������� � forceValue.
                    freq = currBC(1,6);
                    % ������������ ������� ������ ����� ��� ������� ����
                    % �� �������.
                    for i=1:tsNum
                        this.F(glDOF1,i) = this.F(glDOF1,i)+...
                            forceValue(1)*sin((2*pi*freq)*(i*tStep));
                        this.F(glDOF2,i) = this.F(glDOF2,i)+...
                            forceValue(2)*sin((2*pi*freq)*(i*tStep));
                    end
                end
            end
        end
        % ����� ������� ������� ������������ ����������.
        function RunStatic(this)
            % --> ������ �������.
            % ���������� �� � �� ��� ��. ��������, ��� ���������� �������.
            KnoBC = this.K;
            MnoBC = this.M;
            % ��������� ��.
            this.ApplyBC();
            % ������� �������, ����������� �����������. �����.
            dspl = this.K\this.F;
            disp('DOFs (displ. components):')
            disp(dspl);
            % ����������� �������. �����.
            reacts = KnoBC*dspl-this.F;
            disp('Reactions (components):')
            disp(reacts);
            % �������������� �� � �� ��� ��������� ��������.
            this.K = KnoBC;
            this.M = MnoBC;
        end
        % ����� ������� ������� ����������� ���������.
        function RunModal(this)
            % --> ������ ����������� ���������.
            % ���������� �� � �� ��� ��.
            KnoBC = this.K;
            MnoBC = this.M;
            % ��������� ��.
            this.ApplyBCEig();
            % ������� ��������� ������.
            freqSol = (1/(2*pi))*sqrt(eig(this.K, this.M));
            disp('Natural frequencies (Hz):')
            disp(freqSol);
            % �������������� �� � �� ��� ��������� ��������.
            this.K = KnoBC;
            this.M = MnoBC;
        end
        % ����� ������� ������� �������� �� �������� ������.
        function RunTransient(this,tStep,tDur,node,dofToPlot)
            % this  - ������ ��� ������ � ������ (������� ��������),
            % tStep - ��� �� �������,
            % tDur  - ����� ������������� �����,
            % node  - ���� � ������� �������� ������ �� �������.
            % doftoplot - ����� �� � ���� ��� ������.
            % ����� ����� ��������� �����.
            tsNum = fix(tDur/tStep);
            % ������� ��� ������� ���������, ��������� � �����������.
            nn = this.mesh.numberOfNodes;
            dpn = this.mesh.dofPerNode;
            acsNodal = zeros(nn*dpn,1);
            speNodal = zeros(nn*dpn,1);
            dspNodal = zeros(nn*dpn,1);
            % ��������� ������� ������ ����� � ���� ��� ���� �����.
            this.F = zeros(nn*dpn,tsNum);
            % ��.
            this.ApplyBCTrt(tStep,tsNum);
            % ���������� ��� ������� �������������� ��������.
            delta = 0.5;
            alfa = 0.25;
            a0 = 1/(alfa*(tStep^2));
            a1 = delta/(alfa*(tStep));
            a2 = 1/(alfa*(tStep));
            a3 = (1/(2*alfa))-1;
            a4 = (delta/alfa)-1;
            a5 = (tStep/2)*((delta/alfa)-2);
            a6 = tStep*(1-delta);
            a7 = delta*tStep;
            % ��������� �� �� �� � ��.
            this.ApplyBC();
            % ������������ ����������� ������� ���������.
            Khat = this.K+a0*this.M;
            % ��� ������� ���� �� ������� ������� �����������.
            for i=1:tsNum
                % ����������� ��������.
                Rhat = this.F(:,i)+this.M*(a0*dspNodal(:,i)+a2*speNodal(:,i)+...
                    a3*acsNodal(:,i));
                % ���������� ����������� ��� ���������� ���� �� �������.
                dspNodal(:,i+1) = Khat\Rhat;
                % ���������� ���������.
                acsNodal(:,i+1) = a0*(dspNodal(:,i+1)-dspNodal(:,i))-...
                    a2*speNodal(:,i)-a3*acsNodal(:,i);
                % ���������� ��������.
                speNodal(:,i+1) = speNodal(:,i)+a6*acsNodal(:,i)+...
                    a7*acsNodal(:,i+1);
            end
            % ���������� �������.
            timeSpan = 0:tStep:tsNum*tStep;
            % ������ �����������.
            subplot(2,1,1);
            plot(timeSpan,dspNodal(node*dpn-dpn+dofToPlot,:));
            title('Displacement (Selected DOF)');
            % ������ �������.
            RealFFT = fft(dspNodal(node*dpn-dpn+dofToPlot,:));
            % ����� �������.
            nsmp = length(RealFFT);
            % ������� �������������.
            smplFreq = 1/tStep;
            % ������� �������.
            domainFFT = (0:nsmp-1)*smplFreq/nsmp;
            % ������.
            absFFT = abs(RealFFT);
            subplot(2,1,2);
            plot(domainFFT,absFFT);
            title('Spectrum');
            hold off;
        end
    end
end

