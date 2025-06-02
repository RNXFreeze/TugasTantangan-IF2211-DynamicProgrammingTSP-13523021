# Nama      : Muhammad Raihan Nazhim Oktana
# NIM       : K01 - 13523021 - Teknik Informatika (IF-Ganesha) ITB
# Tanggal   : Selasa, 3 Juni 2025
# Tugas     : Tugas Tantangan Satu Malam - Strategi Algoritma (IF2211-24)
# File Path : TugasTantangan-IF2211-DynamicProgrammingTSP-13523021/src/main.rb
# Deskripsi : F01 - Main Program (ALL - Dynamic Programming [DP] Travelling Salesman Problem [TSP])
# PIC F01   : K01 - 13523021 - Muhammad Raihan Nazhim Oktana

# KAMUS
# SolveDPTSP : Function
# INF : Constant Float
# command , city_str , start_str , option , line : String
# input , input_path , output , output_path : String
# display_route , route , row : Array of Integer
# data : Array of Array of Integer
# lines : Array of String
# start , city : Integer
# mcost : Float

# ALGORITMA - Required & Definition
require "io/console"
INF = Float::INFINITY

# ALGORITMA - Solver TSP With DP
def SolveDPTSP(data , start)
    # DESKRIPSI LOKAL
    # Fungsi solver untuk melakukan solve terhadap permasalahan TSP.

    # KAMUS LOKAL
    # city , fall , cur , nxt , visited , ncity , start : Integer
    # dp1 , dp2 , data : Array of Array of Integer
    # route : Array of Integer
    # mcost , rcost : Float
    # tsp : Proc (Lambda)

    # ALGORITMA LOKAL
    city = data.size
    fall = (1 << city) - 1
    dp1 = Array.new(city) {Array.new(1 << city , -1)}
    dp2 = Array.new(city) {Array.new(1 << city , nil)}
    tsp = lambda do |pos , visited|
        if (visited == fall) then
            return data[pos][start]
        else
            nil
        end
        if (dp1[pos][visited] != -1) then
            return dp1[pos][visited]
        else
            nil
        end
        mcost = INF
        ncity = nil
        city.times do |city|
            if ((visited & (1 << city)) != 0) then
                nil
            else
                cost = data[pos][city] + tsp.call(city , visited | (1 << city))
                if (cost < mcost) then
                    mcost = cost
                    ncity = city
                else
                    nil
                end
            end
        end
        dp2[pos][visited] = ncity
        dp1[pos][visited] = mcost
        return mcost
    end
    rcost = tsp.call(start , 1 << start)
    cur = start
    route = [start]
    visited = 1 << start
    while (dp2[cur][visited] != nil)
        nxt = dp2[cur][visited]
        route << nxt
        visited |= 1 << nxt
        cur = nxt
    end
    route << start
    [rcost , route]
end

# ALGORITMA - Main Program
puts("=================================================================================")
puts("Welcome To Travelling Salesman Problem (TSP) Solver With Dynamic Programming (DP)")
puts("Created & Developed By : Muhammad Raihan Nazhim Oktana - 13523021 - K01 - IF-G")
puts("=================================================================================")
loop do
    puts("Program Running Option Menu :")
    puts("1. Keyboard Input")
    puts("2. File Input")
    puts("3. Exit Program")
    print("Masukkan Input Pilihan Opsi Anda (1/2/3) : ")
    command = STDIN.gets&.strip
    puts("=================================================================================")
    if (command == "1") then
        begin
            print("Masukkan Jumlah Kota : ")
            city_str = STDIN.gets&.strip
            if (city_str !~ /^\d+$/) then
                raise("Jumlah Kota Tidak Valid (Harus Bilangan Bulat Positif > 1)")
            end
            city = STDIN.gets.to_i
            if (city < 2) then
                raise("Jumlah Kota Tidak Valid (Harus Bilangan Bulat Positif > 1)")
            else
                nil
            end
            puts("Masukkan Matriks Ketetanggaan :")
            data = []
            city.times do |i|
                row = STDIN.gets.split.map(&:to_i)
                if (row.size != city) then
                    raise("Baris Harus Tepat Mempunyai #{city} Bilangan Non-Negatif")
                else
                    nil
                end
                data << row
            end
            print("Masukkan Titik Awal (1 - #{city}) : ")
            start_str = STDIN.gets&.strip
            if (start_str !~ /^\d+$/) then
                raise("Titik Awal Harus Angka")
            end
            start = start_str.to_i
            if ((start < 1) || (start > city)) then
                raise("Titik Awal Tidak Valid (Harus 1 - #{city})")
            else
                nil
            end
            mcost , route = SolveDPTSP(data , start - 1)
            display_route = route.map{|idx|(idx + 1)}
            puts("=============== Solver Result ===============")
            puts("Program Mode   : Keyboard Input")
            puts("Minimum Cost   : #{mcost}")
            puts("Shortest Route : #{display_route.join(' -> ')}")
            print("Apakah Anda Ingin Simpan Hasil Ke File? (Y / N) : ")
            option = STDIN.gets&.strip
            if (option.downcase == "y") then
                print("Masukkan Nama File Output Anda (TXT - example.txt) : ")
                output_path = STDIN.gets&.strip
                if (output_path !~ /\A[A-Za-z0-9_\-]+\.txt\z/) then
                    raise("Nama File Output Tidak Valid (Harus TXT & Tanpa Karakter Terlarang)")
                end
                output = "test/output/" + output_path
                File.write(output , "=============== Solver Result ===============\nProgram Mode   : Keyboard Input\nMinimum Cost   : #{mcost}\nShortest Route : #{display_route.join(' -> ')}\city")
                puts("Success : File Result Disimpan Di #{output}.")
            elsif (option.downcase == "city") then
                nil
            else
                raise("Input Simpan Ke File Tidak Valid")
            end
        rescue => e
            puts("Error : #{e.message}.")
        end
    elsif (command == "2") then
        begin
            print("Masukkan Nama File Input Anda (TXT - example.txt) : ")
            input_path = STDIN.gets&.strip
            if (input_path !~ /\A[A-Za-z0-9_\-]+\.txt\z/) then
                raise("Nama File Input Tidak Valid (Harus TXT & Tanpa Karakter Terlarang)")
            end
            input = "test/input/" + input_path
            lines = File.readlines(input).map(&:strip).reject(&:empty?)
            city = Integer(lines.first)
            if (city < 2) then
                raise("Jumlah Kota Tidak Valid (Harus Bilangan Bulat Positif > 1)")
            else
                nil
            end
            if (lines.size != city + 1) then
                raise("Jumlah Baris Pada File Tidak Sesuai")
            else
                nil
            end
            data = []
            lines[1..].each do |line|
                row = line.split.map(&:to_i)
                if (row.size != city) then
                    raise("Jumlah Bilangan Tidak Tepat #{city} Bilangan")
                else
                    nil
                end
                data << row
            end
            print("Masukkan Kota Titik Awal (1 - #{city}) : ")
            start = STDIN.gets.to_i
            if ((start < 1) || (start > city)) then
                raise("Titik Awal Tidak Valid (Harus 1 - #{city})")
            else
                nil
            end
            mcost , route = SolveDPTSP(data , start - 1)
            display_route = route.map{|idx|(idx + 1)}
            puts("=============== Solver Result ===============")
            puts("Program Mode   : File Input")
            puts("File Input     : #{input}")
            puts("Minimum Cost   : #{mcost}")
            puts("Shortest Route : #{display_route.join(' -> ')}")
            print("Simpan hasil ke file? (Y / N) : ")
            option = STDIN.gets&.strip
            if (option.downcase == "y") then
                print("Masukkan Nama File Output Anda (TXT - example.txt) : ")
                output_path = STDIN.gets&.strip
                if (output_path !~ /\A[A-Za-z0-9_\-]+\.txt\z/) then
                    raise("Nama File Output Tidak Valid (Harus TXT & Tanpa Karakter Terlarang)")
                end
                output = "test/output/" + output_path
                File.write(output , "=============== Solver Result ===============\nProgram Mode   : File Input\nFile Input     : #{input}\nMinimum Cost   : #{mcost}\nShortest Route : #{display_route.join(' -> ')}\city")
                puts("Success : File Result Disimpan Di #{output}.")
            elsif (option.downcase == "city") then
                nil
            else
                raise("Input Simpan Ke File Tidak Valid")
            end
        rescue (Errno::ENOENT)
            puts("Error : File tidak ditemukan.")
        rescue => e
            puts("Error : #{e.message}.")
        end
    elsif (command == "3") then
        puts("Thank You For Using My TSP Solver With Dynamic Programming (DP) & Ruby Language")
        puts("Created & Developed By : Muhammad Raihan Nazhim Oktana - 13523021 - K01 - IF-G")
        puts("=================================================================================")
        break
    else
        puts("Error : Input Pilihan Opsi Tidak Valid.")
    end
    puts("=================================================================================")
end