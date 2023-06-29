local showingBreakingNews = false
local scaleform = nil
local scaleformId = nil

RegisterCommand('breakingnews', function(source, args)
    local newsText = table.concat(args, ' ')
    StartBreakingNews(newsText)
end)

function StartBreakingNews(newsText)
    if showingBreakingNews and newsText == '' then
        StopBreakingNews()
        return
    end

    showingBreakingNews = true

    Citizen.CreateThread(function()
        scaleformId = RequestScaleformMovie("breaking_news")

        while not HasScaleformMovieLoaded(scaleformId) do
            Citizen.Wait(0)
        end

        DrawBreakingNews(scaleformId, newsText)

        while showingBreakingNews do
            Citizen.Wait(0)

            DrawScaleformMovieFullscreen(scaleformId, 255, 255, 255, 255)
        end

        StopScaleformMovie(scaleformId)
        SetScaleformMovieAsNoLongerNeeded(scaleformId)
    end)
end

function StopBreakingNews()
    if showingBreakingNews then
        showingBreakingNews = false
        StopScaleformMovie(scaleformId)
        SetScaleformMovieAsNoLongerNeeded(scaleformId)
    end
end

function DrawBreakingNews(scaleformId, newsText)
    BeginScaleformMovieMethod(scaleformId, "SET_TEXT")
    PushScaleformMovieMethodParameterString(newsText)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleformId, "SET_BRAND_NAME")
    PushScaleformMovieMethodParameterString("Weazel News")
    EndScaleformMovieMethod()
end
