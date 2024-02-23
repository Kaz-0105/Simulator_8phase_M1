classdef yaml<handle
    properties (GetAccess = public)
        inpx_file = ""; 
        layx_file = "";
        graphic_mode = 0;
        seed = 0;
        predictive_horizon = 0;     % 予測ホライゾン
        control_horizon = 0;        % 制御ホライゾン
        time_step = 0;              % タイムステップ
        control_interval = 0;       % 制御のインターバル時間
        num_loop = 0;               % MPCのサイクルのループ回数
        sim_count = 0;              % シミュレーションする時間
        sim_resolution = 0;         % シミュレーション時間で1sあたりに何回自動車の位置を更新するか(解像度)
        control_mode = 'off';
        prediction_model = 'Dan';
        model_prms = [];
        groups = {};
    end

    methods(Access = public)
        function obj = yaml(file_name, file_dir)
            data = yaml.loadFile(append(file_dir, file_name));

            % inpxファイルの設定
            
            [inpx_dir, inpx_name, inpx_ext] = fileparts(data.inpx_file);

            if strlength(inpx_dir) == 0
                obj.inpx_file = append(file_dir, inpx_name, inpx_ext);
            else
                obj.inpx_file = append(pwd,"\", data.inpx_file);
            end

            % layxファイルの設定
            [layx_dir, layx_name, layx_ext] = fileparts(data.layx_file);                    % data.layx_fileをディレクトリ,名前,拡張子に分ける
            
            if strlength(layx_dir) == 0
                obj.layx_file = append(file_dir,layx_name,layx_ext);                        % ファイル名のみしかyamlファイルに記載されていない場合は,yamlファイルと同じディレクトリに存在するとする
            else
                obj.layx_file = append(pwd, "\", data.layx_file);                        % ディレクトリまで記載があった場合は,そのまま
            end

            % グラフィックモードの設定
            try
                obj.graphic_mode = data.graphic_mode;
            catch
                obj.graphic_mode = 0;
            end

            % シード値の設定
            try
                obj.seed = data.seed;
            catch
                obj.seed = randi(100);
            end

            % シミュレーションの解像度の設定（シミュレーション内の時間で1秒間に何回自動車の位置を更新するか）
            try
                obj.sim_resolution = data.sim_resolution;
            catch
                obj.sim_resolution = 10;
            end

            % 予測ホライゾンの設定
            obj.predictive_horizon = data.predictive_horizon;

            % 制御ホライズンの設定
            obj.control_horizon = data.control_horizon;

            % タイムステップの設定
            obj.time_step = data.time_step;

            % 制御のインターバル時間の設定
            obj.control_interval = obj.control_horizon*obj.time_step;

            % MPCのサイクルのループの回数
            obj.num_loop = data.num_loop;

            % シミュレーションの回数
            obj.sim_count = data.sim_count;

            % 制御モードの設定
            try
                obj.control_mode = data.control_mode;
            catch 
                obj.control_mode = 'off';
            end

            % 予測モデルの設定
            try 
                obj.prediction_model = data.prediction_model;
            catch
                obj.prediction_model = 'Dan';
            end

            if strcmp(obj.prediction_model,'Dan')
                prms_data = yaml.loadFile(append(file_dir, 'config_dan.yaml'));
                obj.model_prms.m = prms_data.m;
                obj.model_prms.N_s = prms_data.N_s;
                obj.model_prms.eps = prms_data.eps;
                obj.model_prms.fix_num = prms_data.fix_num;
            elseif strcmp(obj.prediction_model,'Newell')
            end

            % group構造体の作成（道路の配置や進路割合などをまとめた構造体）

            group_files = data.groups;
            for group_file = group_files
                group_file = group_file{1};
                roads_file = group_file{1};
                intersections_file = group_file{2};

                [roads_file_dir, roads_file_name, roads_file_ext] = fileparts(roads_file);
                [intersections_file_dir, intersections_file_name, intersections_file_ext] = fileparts(intersections_file);

                if strlength(roads_file_dir) == 0
                    roads_file = append(file_dir, roads_file_name, roads_file_ext);
                end

                if strlength(intersections_file_dir) == 0
                    intersections_file = append(file_dir, intersections_file_name, intersections_file_ext);
                end

                obj.groups{end+1} = config.yaml.parse_group(roads_file, intersections_file);  % 1つのエリアの情報をまとめたgroup構造体をgroupsとしてセル配列にまとめる
            end
        end
    end

    methods(Access = private)
    end

    methods(Static)
        group = parse_group(roads_file, intersections_file);
    end
    
end

