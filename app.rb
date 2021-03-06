require "sinatra"
require "sinatra/reloader"
require "rest-client"
require "json"
require "httparty"
require "nokogiri"
require "uri"
require "date"
require 'csv'

before do
    p "*********************************"
    p params
    p request.path_info #사용자가 요청보낸 경로
    p request.fullpath # 파라미터까지 포함한 경로
    p "*********************************"
end


get '/' do
  'Hello world!'
end

get '/htmlfile' do
    'Hello world!'
    send_file "views/htmlfile.html"
end

get "/htmltag" do
    "<h1>html태그를 보낼수 있습니다.<h1>
    
    <ui>
        <li>1</li>
        <li>2</li>
        <li>3</li>
    </ui>
    "
end

get '/welcome/:name' do
    "#{params[:name]}님 안녕하세요."
end

get '/cube/:num' do
    # input = params[:num].to_i
    # result = input **3
    # puts "************************************"
    # puts input.class
    # puts result
    # puts "************************************"
    #return "#{result}"
        
    "#{params[:num].to_i**3}"

    
end


get "/erbfile" do
        @name = "Hyunwoo"
        erb :erbfile
end

get '/lunch-array' do
    # 메뉴들을 배열에 저장한다.
    munu = ["bread", "pasta","piza"]
    # 하나를 추천한다.
    #result = munu.sample
    # arb 파일에 담아서 랜더링한다. 
    #return result
    
    @result = munu.sample
    
    erb :luncharray
end


get '/lunch-hash' do
    #메뉴들에 저장된 배열을 만든다.
    menu = ["피자", "스시","치킨"]
    
    #메뉴 이름(key) , 사진url(value) 를 가진 
    #가진 hash 를 만든다.
    munu_img = { 
        "피자" => "https://akamai.pizzahut.co.kr/images/products/top/P_RG_GB_3.jpg",
        "스시" =>"http://cfile27.uf.tistory.com/image/2378144C54D9FD421EAA80", 
        "치킨" => "data:image/jpeg;base64,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" 
    } 
    
    #랜덤으로 하나를 출력한다.
    @munu_result = menu.sample
    @munu_img = munu_img[@munu_result]  # munu_result는 위의 url을 나타나게 된다.
    
    #이름과 url를 넘겨서 erb를 랜더링한다.
    erb :lunchhash
    
end

get '/randomgame:name' do
    random = ["부","결혼운", "명예","인간관계" ]
    random_txt = {
        "부" => "당신은 재벌이 될 것입니다.",
        "결혼운" => "당신은 곧 결혼할 사람이 나타날거에요",
        "명예" => "당신은 명예를 얻을거에요",
        "인간관계" => "프로젝트 혼자서 하게 될거에요"
    }
    @name = params[:name]
    @random_result = random.sample
    @random_txt = random_txt[@random_result]
    
    erb :future
end

get '/lotto.sample' do
    # @lotto = (1..45).to_a.sample(6).sort
    @lotto = [6,11,15,17,39,40]
    
    
    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    @lotto_info = RestClient.get(url)
    @lotto_hash = JSON.parse(@lotto_info)
    
    
    @winner = []
    
    @lotto_hash.each do |k, v|
        if k.include?('drwtNo') 
            #배열에 저장
            @winner << v  # @winner.push 이거해도 됨
        end
    end
    

    # winner 와 lotto 를 비교해서 
    # 몇개가 일치하는지 계산
    
    @matchNum = (@winner&@lotto).length
    @bonusnum = @lotto_hash["bnusNo"]
    #@lotto.include(@bonusnum)
    
    # 몇등인지?? 
    
    
    @result="꽝"
    
    
    if (@matchNum == 6) then @result = "1등"    
    elsif (@matchNum == 5 && @lotto.include?(@bonusnum) ) 
        @result="2등"
    elsif (@matchNum == 5 ) then  @result="3등"
    elsif (@matchNum == 4 ) then  @result="4등"
    elsif (@matchNum == 3 ) then  @result="5등"
    end
    
    
    @result1 = case [@matchNum, @lotto.include?(@bonusnum)]
    when [6, false] then "1등"
    when [5, true] then "2등"
    when [5, false] then "3등"
    when [4, false] then "4등"
    when [3, false] then "5등"
    else "꽝"
    end
    
    erb :lotto
end


get '/form' do 
    erb :form
end

get '/search' do
    @keyword = params[:keyword]
    url = 'https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=1&ie=utf8&query='
    #erb :search
    redirect to (url+@keyword)
end


get '/opgg' do
    erb :opgg
end

get '/opggresult' do
    url = 'http://www.op.gg/summoner/userName='
    @userName = params[:userName]
    @encodeName =URI.encode(@userName)
    
    @res = HTTParty.get(url+ @encodeName)
    @doc = Nokogiri::HTML(@res.body)
    
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins").text
    @lose =  @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses").text
    @rank =  @doc.css("body > div.l-wrap.l-wrap--summoner > div.l-container > div > div > div.Header > div.Profile > div.Information > div > div > a > span").text
    
    @persent = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.winratio").text
    
    # File.open('opgg.txt', 'a+') do |file|
    #     file.write("#{@userName},#{@win},#{@lose},#{@rank}\n")
    # end
    
    CSV.open('opgg.csv','a+') do |c|
        c << [@userName, @win, @lose, @rank]
    end
    
    erb :opggresult
end