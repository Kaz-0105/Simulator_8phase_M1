classdef vissim_measurements < handle

    properties(GetAccess = public)
    end

    properties(GetAccess = private)
        vis_obj;          % VissimのCOMオブジェクト

        input_data_map;   % 末端道路ごとの流入量の時系列データ格納するディクショナリ
        output_data_map;  % 末端道路ごとの流出量の時系列データ格納するディクショナリ
        queue_data_map;   % 交差点ごとの待ち行列の時系列データを格納するディクショナリ
        calc_time_data_map;   % 交差点ごとの計算時間の時系列データを格納するディクショナリ
        num_vehs_data_map;   % 交差点ごとの車両数の時系列データを格納するディクショナリ

        link_DC_measurement_map; % キー：リンクのID、バリュー：Data Collection measurementのIDのディクショナリ
    end

    methods(Access = public)

        function obj = vissim_measurements(vis_obj)

            obj.vis_obj = vis_obj;
            obj.input_data_map = dictionary(int32.empty, cell.empty);
            obj.output_data_map = dictionary(int32.empty, cell.empty);
            obj.queue_data_map = dictionary(int32.empty, struct.empty);
            obj.calc_time_data_map = dictionary(int32.empty, cell.empty);
            obj.num_vehs_data_map = dictionary(int32.empty, cell.empty);

            obj.link_DC_measurement_map = dictionary(int32.empty, int32.empty);
            obj.make_link_DC_measurement_map();

        end

        function update_data(obj, maps, controllers)
            
            obj.update_input_output_data(maps);
            obj.update_queue_data(maps);
            obj.update_calc_time_data(controllers);
            obj.update_num_vehs_data(controllers);
        end

        function [input_data_map, output_data_map] = get_input_output_data_map(obj)
            input_data_map = obj.input_data_map;
            output_data_map = obj.output_data_map;
        end

        function queue_data_map = get_queue_data_map(obj)
            queue_data_map = obj.queue_data_map;
        end

        function calc_time_data_map = get_calc_time_data_map(obj)
            calc_time_data_map = obj.calc_time_data_map;
        end

        function num_vehs_data_map = get_num_vehs_data_map(obj)
            num_vehs_data_map = obj.num_vehs_data_map;
        end
    end

    methods(Access = private)

        % Data Collection Pointのリンクごとのディクショナリを作成する関数
        make_link_DC_measurement_map(obj)

        % 計測データの更新を行う関数
        update_input_output_data(obj, maps)
        update_queue_data(obj, maps)
        update_calc_time_data(obj, controllers)
        update_num_vehs_data(obj, controllers)

    end

    methods(Static)
    end
end