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
        % ��� �� ������� (def=0).
        ts=0
        % ����� ����� �� ������� (def=0).
        tsNum=0
        % ����� ������ (def=0).
        tDur=0
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
            % ���� � ����������� �� ���-�� �� �� ����.
            dofPerNode = obj.mesh.dofPerNode;
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
                    GlobM, obj.mesh.iMnod);
            end
            obj.K = GlobK;
            obj.M = GlobM;
            % ������ ������ ����� (���). ������������ ��� ��.
            obj.F = zeros(obj.mesh.numberOfNodes*dofPerNode,1);
            
        end
        % ����� ��������� �� �������. ��������� �� �� � ��.
        % ����� ��� �������, �������� � ������. ���������.
        function ApplyFixBC(this)
            BCs = this.mesh.allFixBCs;
            BCtotal = this.mesh.numberOfFixBCs;
            for i=1:BCtotal
                % ����� ��
                currBC = BCs(i,:);
                % ����� ��� ��.
                typeBC = currBC(1);
                % ����� ����� ����.
                nnumBC = currBC(2);
                % ��������� ����� ������� ������� � ����. ��, MM, ���.
                GLDOFs = this.mesh.iMnod(nnumBC,:);
                % ��������� �� � �� � ��.
                % ������� ���� ��. �������� ������, ������� � �������� 1 �� ���������.
                if (typeBC==1)
                    for dofNum=1:this.mesh.dofPerNode
                        % ������� ����.
                        this.M(GLDOFs(dofNum),:)=0; % �������� ������.
                        this.M(:,GLDOFs(dofNum))=0; % �������� �������.
                        this.M(GLDOFs(dofNum),GLDOFs(dofNum))=1; % �������.
                        % ������� ���������.
                        this.K(GLDOFs(dofNum),:)=0;
                        this.K(:,GLDOFs(dofNum))=0;
                        % ���� ������ �����������, �� �� ������ ���������
                        % ����������� (� ������ ��� �������� �� ���������)
                        if this.ts==0
                            this.K(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        end
                    end
                end
                % ������� ����� ���. ��, �������� ���, ����� ������ ��.
                if (typeBC==2)
                    for dofNum=1:this.mesh.dofPerNode
                        % ���������� ������ ��.
                        if dofNum==1
                            continue
                        end
                        % ������� ����.
                        this.M(GLDOFs(dofNum),:)=0;
                        this.M(:,GLDOFs(dofNum))=0;
                        this.M(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        % ������� ���������.
                        this.K(GLDOFs(dofNum),:)=0;
                        this.K(:,GLDOFs(dofNum))=0;
                        % ���� ������ �����������, �� �� ������ ���������
                        % ����������� (� ������ ��� �������� �� ���������)
                        if this.ts==0
                            this.K(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        end
                    end
                end
                % ������� ����� ����. ��, �������� ���, ����� ������ ��.
                if (typeBC==3)
                    for dofNum=1:this.mesh.dofPerNode
                        % ���������� ������ ��.
                        if dofNum==2
                            continue
                        end
                        % ������� ����.
                        this.M(GLDOFs(dofNum),:)=0;
                        this.M(:,GLDOFs(dofNum))=0;
                        this.M(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        % ������� ���������.
                        this.K(GLDOFs(dofNum),:)=0;
                        this.K(:,GLDOFs(dofNum))=0;
                        % ���� ������ �����������, �� �� ������ ���������
                        % ����������� (� ������ ��� �������� �� ���������)
                        if this.ts==0
                            this.K(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        end
                    end
                end
                % ������� ���� ����� ���� ��������.
                if (typeBC==4)
                    for dofNum=1:this.mesh.dofPerNode
                        % ���������� ������ ��.
                        if dofNum==3
                            continue
                        end
                        % ������� ����.
                        this.M(GLDOFs(dofNum),:)=0;
                        this.M(:,GLDOFs(dofNum))=0;
                        this.M(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        % ������� ���������.
                        this.K(GLDOFs(dofNum),:)=0;
                        this.K(:,GLDOFs(dofNum))=0;
                        % ���� ������ �����������, �� �� ������ ���������
                        % ����������� (� ������ ��� �������� �� ���������)
                        if this.ts==0
                            this.K(GLDOFs(dofNum),GLDOFs(dofNum))=1;
                        end
                    end
                end
            end
        end
        % ����� ��������� �� ������.
        function ApplyForceBC(this)
            BCs = this.mesh.allForceBCs;
            BCtotal = this.mesh.numberOfForceBCs;
            for i=1:BCtotal
                % ����� ��
                currBC = BCs(i,:);
                % ����� ��� ��.
                typeBC = currBC(1);
                % ����� ����� ����.
                nnumBC = currBC(2);
                % ��������� ����� �������� ������� � ����. ���.
                GLDOFs = this.mesh.iMnod(nnumBC,:);
                % ��������� �� � ���.
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
                % ���� �������������� ���� �������������, ������� tsNum
                % �������� � ����������� ���������� ���.
                if typeBC==11
                    % �������� �� ������� �� ApplyForceBC ��� tStep.
                    if this.ts==0
                        error('No timestep during harm. BC application!');
                    end
                    forceValue = zeros(3,1);
                    % ������� Fx,Fy,Fz � forceValue.
                    forceValue(1) = currBC(1,3);
                    forceValue(2) = currBC(1,4);
                    forceValue(3) = currBC(1,5);
                    % ������� ������� � forceValue.
                    freq = currBC(1,6);
                    % ������������ ������� ������ ����� ��� ������� ����
                    % �� �������.
                    for s=1:this.tsNum
                        this.F(GLDOFs(1),s) = this.F(GLDOFs(1),s)+...
                            forceValue(1)*sin((2*pi*freq)*(s*this.ts));
                        this.F(GLDOFs(2),s) = this.F(GLDOFs(2),s)+...
                            forceValue(2)*sin((2*pi*freq)*(s*this.ts));
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
            this.ApplyFixBC();
            this.ApplyForceBC();
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
            this.ApplyFixBC();
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
            % ��������� � ���� ������� ������: ����� ����� ���������
            % �����, ������������ ������ � ���.
            this.tsNum = fix(tDur/tStep);
            this.tDur = tDur;
            this.ts = tStep;
            % ������� ��� ������� ���������, ��������� � �����������.
            nn = this.mesh.numberOfNodes;
            dpn = this.mesh.dofPerNode;
            acsNodal = zeros(nn*dpn,1);
            speNodal = zeros(nn*dpn,1);
            dspNodal = zeros(nn*dpn,1);
            % ��������� ������� ������ ����� � ���� ��� ���� �����.
            this.F = zeros(nn*dpn,this.tsNum);
            % ��.
            this.ApplyFixBC();
            this.ApplyForceBC();
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
            this.ApplyFixBC();
            % ������������ ����������� ������� ���������.
            Khat = this.K+a0*this.M;
            % ��� ������� ���� �� ������� ������� �����������.
            for i=1:this.tsNum
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
            timeSpan = 0:tStep:this.tsNum*tStep;
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

