require 'nokogiri'
require 'mechanize'




class BbtScraping

	def initialize
      @mecha = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
        agent.follow_meta_refresh = true
        agent.default_encoding = 'EUC-JP'
        agent.force_default_encoding = true
      }
		end

	def scoreGet(loginId,password)


		agent.get('https://aircamp.us/course/result') do |page|

		mypage = page.form_with(id: 'loginForm') do |form|
			# ログインに必要な入力項目を設定していく
			# formオブジェクトが持っている変数名は入力項目(inputタグ)のname属性
			form.userId = loginId
			form.password = password
		end.submit

				#HTML読み込み
				doc = Nokogiri::HTML(mypage.content.toutf8)

				scores = []


				course_count = 0
				score_gpas = 0
				score_gpa = 0
								doc.xpath("/html/body/div[contains(@id,'container')]/div[contains(@class,'container_box')]/div[contains(@id,'content')]/div[contains(@id,'main')]/div/div[contains(@class,'result-box')]/div/div[contains(@class,'score-result')]").each do |node|

									# 絞り込んでTitle部分を抽出:
									 score = node.xpath("./p[contains(@class,'score')]/text()")
									course = node.xpath("./h4/a/text()")


									if score.to_s.eql?("A+")
										score_gpa = 4
										course_count = course_count + 1
									elsif score.to_s.eql?("A")
										score_gpa = 3
										course_count = course_count + 1

									elsif score.to_s.eql?("B")
										score_gpa = 2
										course_count = course_count + 1
									elsif score.to_s.eql?("C")
										score_gpa = 1
										course_count = course_count + 1
									elsif score.to_s.eql?("F")
										score_gpa = 0
										course_count = course_count + 1
									else
										score_gpa = 0
									end
									score_gpas += score_gpa

									scores.push({"course" => course.to_s,"score" => score.to_s,"score_gpa"=>score_gpa})


								end




								return {"scores" => scores, "gpa" => (score_gpas.to_f / course_count).round(2).to_s}

								end
				end

	def taskGet(loginId,password)
					agent = Mechanize.new
					agent.user_agent_alias = 'Mac Safari 4'
					agent.follow_meta_refresh = true

					courseArray = []

					agent.get('http://aircamp.us/course/13762/information?tag_id=31&cmplid=1874017') do |page|

						mypage = page.form_with(id: 'loginForm') do |form|
							# ログインに必要な入力項目を設定していく
							# formオブジェクトが持っている変数名は入力項目(inputタグ)のname属性
							form.userId = loginId
							form.password = password
						end.submit
						doc = Nokogiri::HTML(mypage.content.toutf8)
						p doc
						doc.css('.info > p > a').each do |link|
							courseArray.push('http://aircamp.us' + link["href"] + '?tag_id=31&query=unread')
						end


					end
					#HTML読み込み

					taskArray = []
					courseArray.each do |url|
						p url
						sleep(5)
						agent.get(url) do |page|

							doc = Nokogiri::HTML(page.content.toutf8)

							courseName = doc.title
							p courseName
							p page.links
							elements = page.search('a')
							p elements

						end

						#taskArray.push({"courseName" => courseName.to_s,"tasks" => tasks})
					end


	end



end
