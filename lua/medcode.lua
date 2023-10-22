local js = require "js"
local window = js.global
local document = window.document

function setup_stuff()
    local preview = document:getElementById("preview")

    preview.style["color"] = "gray"
    preview.textContent = "hello"

    local input = document:getElementById("input")

    input.value = "liver normal"
    input:addEventListener("input", check_input)
    input:addEventListener("keypress", function(element, event)
        print("Got event:", event, "key:", event.which)
        -- On Enter
        if event.which == 13 then
            submit_input()
        end
    end)
    input:focus()
    input:select()
end

function split_words(sentence)
    local words = {}
    for word in string.gmatch(sentence, "%S+") do
        table.insert(words, word)
    end
    return words
end

function join_words(words)
    local sentence = ""

    for i, word in ipairs(words) do
        if i ~= 1 then
            sentence = sentence .. " "
        end
        sentence = sentence .. word
    end

    return sentence
end

function starts_with(text, prefix)
    return string.sub(text, 1, #prefix) == prefix
end

-- Turn "li" into "liver"
function embiggen_word(word)
    -- The order matters
    local known_words = {"liver", "spleen", "enlarged", "gallbladder"}

    -- "" is technically the start of any word; don't enbiggen it
    if word == "" then
        return ""
    end

    -- Find a bigger variant of this word
    for i, known_word in ipairs(known_words) do
        if starts_with(known_word, word) then
            return known_word
        end
    end

    -- Not found, return the original word
    return word
end

function get_message_and_element(input)
    local preview = "Unknown command"
    local element

    local small_words = split_words(input)

    -- Turn each word in the list to its enbiggened variant
    local words = {}
    for i, small_word in ipairs(small_words) do
        table.insert(words, embiggen_word(small_word))
    end

    if words[1] == "liver" then
    	element = document:getElementById("p-liver")
        if words[2] == "enlarged" then
            preview = "There is a liver in the patient. It looks bigger than the patient."
        else
            preview = "There is a liver in the patient."
        end
    end

    if words[1] == "spleen" then
    	element = document:getElementById("p-spleen")
        if words[2] == "enlarged" then
            preview = "There is a spleen in the patient. It looks bigger than the patient."
        else
            preview = "There is a spleen in the patient."
        end
    end

    if words[1] == "gallbladder" then
    	element = document:getElementById("p-gallbladder")
        if words[2] == "enlarged" then
            preview = "There is a gallbladder in the patient. It looks bigger than the patient."
        else
            preview = "There is a gallbladder in the patient."
        end
    end

    local command = join_words(words)

    return preview, command, element
end

function check_input()
    local input = document:getElementById("input")
    local preview = document:getElementById("preview")

    local message, command, element = get_message_and_element(input.value)

    preview.textContent = command .. " --- " .. message
end

function submit_input(e)
    local input = document:getElementById("input")
    local message, command, element = get_message_and_element(input.value)

    -- Blacken element
    element.classList:remove("not-visited")
    element.classList:add("visited")

    -- Rewrite its text
    element.textContent = message

    -- Find next un-visited
    while true do
        element = element.nextElementSibling
        if element == js.null or element.classList:contains("not-visited") then
            break
        end
    end

    -- Get text from its prefill attribute and put it in the input box
    if element ~= js.null then
        local prefill_with = element:getAttribute("prefill")
        input.value = prefill_with

        -- Refresh preview
        check_input()
    end

    input:focus()
    input:select()
end


setup_stuff()
