local marqueGroup
marqueGroup = display.newGroup()
marqueGroup:setReferencePoint(display.CenterLeftReferencePoint)
marqueGroup.crawlSpeed=2
marqueGroup.crawlDefault = 2

local scaleFactor
scaleFactor = display.contentHeight/1000


-- odata.spit is a function that wraps debug.print

  local infoBar = display.newImage("infobar.png", 0, 0, true)
  infoBar:scale(display.contentWidth/infoBar.width,1*scaleFactor)
  infoBar.x = display.contentCenterX
  infoBar:setReferencePoint(display.CenterReferencePoint)
  infoBar.y = 1+ rssBar.yMin-(infoBar.contentHeight/2)
  infoBar.yShow =infoBar.y
  infoBar.yHide =infoBar.y + infoBar.contentHeight
  infoBar.TransTime = 750
  infoBar.up = true
  infoBar.moving=false
  infoBar.transitionObject = nil
  infoBar.bannerText = nil
  infoBar = odata.setObjectBounds(infoBar)

  local rssBar = display.newImage("rssBackground.png", 0, 0, true)
  rssBar:scale(display.contentWidth/rssBar.width,1*scaleFactor)
  rssBar.x = display.contentWidth*.5
 -- rssBar.y =  navBar.yMin
  rssBar:setReferencePoint(display.CenterReferencePoint)
  rssBar:setReferencePoint(display.CenterReferencePoint)
  rssBar.y = navBar.yMin-(rssBar.contentHeight/2)
  rssBar = odata.setObjectBounds(rssBar)
  rssBar.ready=false
  rssBar.x0 = display.contentCenterX
 
-- -- --for referenece  
-- -- function odata.setObjectBounds(oObject)
-- -- 
-- -- local tBounds =  oObject.contentBounds
-- -- oObject.xMin =  tBounds.xMin
-- -- oObject.yMin =  tBounds.yMin 
-- -- oObject.xMax =  tBounds.xMax
-- -- oObject.yMax =  tBounds.yMax 
-- -- oObject.objectWidth =  tBounds.xMax -  tBounds.xMin
-- -- oObject.objectHeight =  tBounds.yMax -  tBounds.yMin
-- -- 
-- -- tBounds = nil
-- -- return oObject
-- -- end

function startMarque()
      --rssBar is reference
      --odata.spit("Marque Start..." .. marqueGroup.crawlSpeed)




      local function RSSHyperlinkTouch(event)
            odata.spit (event.phase,  "RSSHyperlinkTouch! ")

             if btnHelp.showingHelp==true then
             return true
            end
            if true==odata.appData.showingInfo then
              return true
            end




 --[[
                local iTouchMoveDelta = event.target.startEventX-event.x
                if iTouchMoveDelta<20 then
                      -- quick touch -
                      odata.spit("This was NOT a swipe, not for me? Delta was:" .. iTouchMoveDelta)
                      return false
                else
                      odata.spit("This was a swipe! Delta was: " .. iTouchMoveDelta)
                      return true
                end
--]]


        --
        --if ("ended"==event.phase)==(not(rssBar.isFocus==true)) then

        odata.spit (event.phase,  "RSSHyperlinkTouch! ")

         if event.phase=="began" then
                display.getCurrentStage():setFocus(event.target)
                event.target.startEventX = event.x

         elseif ("moved"==event.phase) then
                odata.spit ("we're moving, letting go",  "RSSHyperlinkTouch! ")
                display.getCurrentStage():setFocus(nil)
                return false

         elseif ("ended"==event.phase) then

            odata.spit ("ended event phase",  "RSSHyperlinkTouch! ")
            display.getCurrentStage():setFocus(nil)
            if infoBar.up==true then
              odata.spit ("I think the infobar is up",  "RSSHyperlinkTouch! ")

              marqueGroup.notactive = true
              infoBar.HideMe()
              share_button.TransTime=300
              open_button.TransTime=300

              share_button.HideMe()
              open_button.HideMe()
              marqueGroup.crawlSpeed =marqueGroup.crawlDefault
              marqueGroup.crawl()


              marqueGroup.notactive = true
              showButton(btnFB)
              showButton(btnInfo)
              showButton(btnRefresh)
              showButton(btnHelp)
              --return true
            else
              odata.spit ("I think the infobar is down",  "RSSHyperlinkTouch! ")
              marqueGroup.notactive = false
              infoBar.ShowMe()
              share_button.TransTime=800
              open_button.TransTime=800
              odata.appData.activeRSS = event.target.rssLinkID
              open_button.myUrl = event.target.myUrl
              share_button.ShowMe()
              open_button.ShowMe()
              hideButton(btnFB)
              hideButton(btnInfo)
              hideButton(btnRefresh)
              hideButton(btnHelp)

              marqueGroup.notactive = false
              return false
            end

         else
              display.getCurrentStage():setFocus(nil)
              return true
          end
      end

      local bGotRSS = odata.appData.gotRSS
      if bGotRSS  then
      local iMarqueTextLeft = 10
      local txtMarque, iconPNG
       rssBar:setReferencePoint(display.CenterReferencePoint)


      local function addMarqueText(sText, tColorR, tColorG, tColorB)
          txtMarque = display.newText(sText,0, 0, native.systemFontBold,  40*scaleFactor )
          --txtMarque:setTextColor(240,230,140)
          txtMarque:setTextColor(tColorR, tColorG, tColorB)
          txtMarque:setReferencePoint(display.CenterLeftReferencePoint)
          txtMarque.x = iMarqueTextLeft
          txtMarque = odata.setObjectBounds(txtMarque )
          local TouchRect = display.newRect(iMarqueTextLeft,  rssBar.y, txtMarque.xMax - txtMarque.xMin, rssBar.contentHeight)
          TouchRect:setReferencePoint(display.CenterLeftReferencePoint)
          TouchRect.strokeWidth = 0
          TouchRect:setFillColor(0,0,0,0)
          --TouchRect.myUrl = odata.RSSLinks.link[i]
          CurrentMarqueY = TouchRect.y
          --TouchRect:addEventListener( "touch", RSSHyperlinkTouch )
          txtMarque.y =   CurrentMarqueY
          --marqueGroup:insert(TouchRect)
          marqueGroup:insert(txtMarque)
          txtMarque = nil
          iMarqueTextLeft = marqueGroup.contentWidth +(40*scaleFactor) -- txtMarqueWidth  + tmWidth --txtMarque.contentWidth --(250*scaleFactor)
      end

      local function addMarqueLink(sText, sLink, lID, tColorR, tColorG, tColorB)
          txtMarque = display.newText(sText,0, 0, native.systemFontBold,  40*scaleFactor )
          --txtMarque:setTextColor(240,230,140)
          txtMarque:setTextColor(tColorR, tColorG, tColorB)
          txtMarque:setReferencePoint(display.CenterLeftReferencePoint)
          txtMarque.x = iMarqueTextLeft
          txtMarque = odata.setObjectBounds(txtMarque )
          local TouchRect = display.newRect(iMarqueTextLeft,  rssBar.y, txtMarque.xMax - txtMarque.xMin, rssBar.contentHeight)
          TouchRect:setReferencePoint(display.CenterLeftReferencePoint)
          TouchRect.strokeWidth = 0
          TouchRect:setFillColor(0,0,0,0)
          TouchRect.rssLinkID = lID
          TouchRect.myUrl = sLink
          CurrentMarqueY = TouchRect.y
          TouchRect:addEventListener( "touch", RSSHyperlinkTouch )
          txtMarque.y =   CurrentMarqueY
          marqueGroup:insert(TouchRect)
          marqueGroup:insert(txtMarque)
          txtMarque = nil
          iMarqueTextLeft = marqueGroup.contentWidth +(40*scaleFactor) -- txtMarqueWidth  + tmWidth --txtMarque.contentWidth --(250*scaleFactor)
      end

      local function addIcon()
        iconPNG = display.newImage(marqueGroup, "Icon.png", system.ResourceDirectory, iMarqueTextLeft, 0, false)
        iconPNG:setReferencePoint(display.CenterLeftReferencePoint)
        local iScale = (iconPNG.height/ rssBar.height)* scaleFactor
        iconPNG:scale(iScale,iScale)
        iconPNG.y = CurrentMarqueY --+(iconPNG.contentHeight/2)
        iMarqueTextLeft = marqueGroup.contentWidth +(iconPNG.contentWidth)
      end



      --Add share score to RSS feed
      --[[
      addMarqueText("Social Share Score:",  240,230,140)
      addMarqueText("GOPageddon:",  0,160,250)
      addMarqueText(odata.ShareScore["g"], 0,160,250)
      addMarqueText(" OBAMAgeddon:", 255,75,0)
      addMarqueText(odata.ShareScore["o"], 255,75,0)
      addIcon()
      --]]


       for i=1, table.maxn(odata.RSSLinks.title) do
       --for i=1, 1 do --table.maxn(odata.RSSLinks.title) do
            local sTitle = odata.RSSLinks.title[i]
            local iMaxLen = 74
            if string.len(sTitle)>(iMaxLen-9) then
              sTitle = string.sub(sTitle,1,(iMaxLen-9)) .. "..."
            end -- this is so long strings are "clipped"
            --sTitle=string.upper(sTitle .. "     ")
            if sTitle==nil then
               odata.spit(i .. " the Title is NOTHING!?!?!")

            end

            addMarqueLink(sTitle,odata.RSSLinks.link[i], i, 240,230,140)
            addIcon()

            --[[
            if (i/3)==math.floor(i/3) then
              addMarqueText("GOPageddon:",  0,160,250)
              addMarqueText(odata.ShareScore["g"], 0,160,250)
              addMarqueText(" OBAMAgeddon:", 255,75,0)
              addMarqueText(odata.ShareScore["o"], 255,75,0)
              addIcon()
            end
            ]]--

       end
           marqueGroup:setReferencePoint(display.CenterReferencePoint)
            odata.spit(marqueGroup.numChildren,"marqueGroup children count after creation: ")

      else
      -- no RSS - tell them to connect and try again...
           odata.spit ("no rss data...")

      end


        --localGroup:insert(marqueGroup)
      marqueGroup:setReferencePoint(display.CenterLeftReferencePoint)
      local iMarqueStart =display.contentWidth+(50)
      --odata.spit(iMarqueStart ,"iMarqueStart : ")
      local iMarqueEnd =0 - marqueGroup.contentWidth-(50)
      --odata.spit(iMarqueEnd ,"iMarqueEnd : ")
      marqueGroup.x = iMarqueStart

      marqueGroup.y = rssBar.y
      --if not (marqueGroup.myTimer==nil) then
      --     timer.cancel(marqueGroup.myTimer)
      --end if


      if not(marqueGroup.myTimer==nil) then
            timer.cancel(marqueGroup.myTimer)
      end


      marqueGroup.myTimer =nil
      marqueGroup.notactive = true
      function marqueGroup.crawl()
         if marqueGroup.notactive then
           local curspeed, defspeed = marqueGroup.crawlSpeed, marqueGroup.crawlDefault
           curspeed = math.floor(curspeed*100)/100

           local relSpeed =  curspeed - defspeed -- we want zero; so for math we have to adjust it. zero out the speed, then add the default
           if (math.floor((relSpeed*100)/100)==0) then
              relSpeed=0
           end

           local adj1 =  (relSpeed/defspeed)*2
           local speedAdjust =(.05 * adj1  )

            if (relSpeed<0) then
                    marqueGroup.crawlSpeed =marqueGroup.crawlSpeed - speedAdjust
            elseif (relSpeed>0) then
                    marqueGroup.crawlSpeed =marqueGroup.crawlSpeed - speedAdjust
            else
                    marqueGroup.crawlSpeed =defspeed

            end

            marqueGroup.x = marqueGroup.x- (marqueGroup.crawlSpeed*scaleFactor)

            if marqueGroup.x < iMarqueEnd then
              marqueGroup.x = iMarqueStart
            elseif marqueGroup.x > iMarqueStart then
              marqueGroup.x = iMarqueEnd
            end
          end
         marqueGroup.myTimer = timer.performWithDelay(10,marqueGroup.crawl)
      end
      marqueGroup.crawl()



    function rssBar.slider(event)
      odata.spit("rssBar.slider fired")
      if btnHelp.showingHelp==true then
         return true
      end
      if true==odata.appData.showingInfo then
          return true
      end

      if rssBar.ready then
            timer.cancel(marqueGroup.myTimer)
            if event.phase=="began" then
                rssBar.x0 = event.x
            end

        --if rssBar.isFocus==true then

            if event.phase=="moved" then
              if infoBar.up==true then
                    odata.spit ("infobar is up")
                    infoBar.HideMe()
                    if marqueGroup.notactive==false then
                        marqueGroup.notactive = true
                        showButton(btnFB)
                        showButton(btnInfo)
                        showButton(btnRefresh)
                        showButton(btnHelp)
                    end
                    share_button.TransTime=300
                    open_button.TransTime=300

                    share_button.HideMe()
                    open_button.HideMe()
                     marqueGroup.notactive=true

              end
                rssBar.isFocus=true
                display.getCurrentStage():setFocus(event.target)
                --odata.spit("rssBar has the focus...")


                --odata.spit (marqueGroup.lastMotionX-event.xStart)
                --marqueGroup.x = marqueGroup.x + (event.x- marqueGroup.x0) --   marqueGroup.x + (marqueGroup.lastMotionX-event.xStart)
                --marqueGroup.lastMotionX =  event.x
                rssBar.time1 = rssBar.time0
                rssBar.time0 = event.time

                local adder = event.x - rssBar.x0
                rssBar.x0 = event.x
                marqueGroup.x = marqueGroup.x + (adder*scaleFactor)
               -- odata.spit (adder, "adder: ")

                if adder>0 then
                   marqueGroup.crawlSpeed=(adder*scaleFactor)*-1 --math.abs(marqueGroup.crawlSpeed)*-1
                elseif adder<0 then
                   marqueGroup.crawlSpeed=(adder*scaleFactor)*-1 --math.abs(marqueGroup.crawlSpeed)
                end

            elseif (event.phase=="ended") or (event.phase=="cancelled") then
                --odata.spit ("touch done")
                rssBar.isFocus=false
                display.getCurrentStage():setFocus(nil)
                --odata.spit("rssBar has released the focus...")

                marqueGroup.crawl()



            else
              return true
            end
        --end

        end
    end

    rssBar:addEventListener( "touch",  rssBar.slider )

    local function setReady()
      rssBar.ready=true
      --native.setActivityIndicator( false )
odata.appData.gettingData = false
    end
    timer.performWithDelay(1000, setReady)


end