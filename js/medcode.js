function setupStuff() {
    $("#preview")
        .css("color", "gray")
        .text("Preview here");

    $("#input")
        .val("liver normal")
        .on('input', checkInput)
        .keypress(e => {
            // Pressed enter
            if (e.which == 13) {
                submitInput();
            }
        })
        .focus()
        .select();
    
    checkInput();
    //document.getElementById('input').setSelectionRange(6,12);
}

// Turn "li" into "liver"
function enbiggen_word(word) {
    // The order matters
    let known_words = ["liver", "spleen", "enlarged", "gallbladder"];

    // "" is technically the start of any word; don't enbiggen it
    if (word == "") {
        return "";
    }

    // Find a bigger variant of this word
    for (known_word of known_words) {
        if (known_word.startsWith(word)) {
            return known_word;
        }
    }

    // Not found, return the original word
    return word;
}

function getMessageAndElement(input) {
    var preview = "Unknown command";
    var element;


    let small_words = input.split(" ");

    // Turn each word in the list to its enbiggened variant
    let words = small_words.map(enbiggen_word);

    if (words[0] == "liver") {
    	element = $("#p-liver");
        if (words[1] == "enlarged") {
            preview = "There is a liver in the patient. It looks bigger than the patient.";
        } else {
            preview = "There is a liver in the patient.";
        }
    }

    if (words[0] == "spleen") {
    	element = $("#p-spleen");
        if (words[1] == "enlarged") {
            preview = "There is a spleen in the patient. It looks bigger than the patient.";
        } else {
            preview = "There is a spleen in the patient.";
        }
    }

    if (words[0] == "gallbladder") {
    	element = $("#p-gallbladder");
        if (words[1] == "enlarged") {
            preview = "There is a gallbladder in the patient. It looks bigger than the patient.";
        } else {
            preview = "There is a gallbladder in the patient.";
        }
    }

    let command = words.join(" ");

    return [preview, command, element];
}

function checkInput(e) {
    let input = $("#input").val();
    
    let [message, command, element] = getMessageAndElement(input);

    $("#preview").text(`${command} --- ${message}`);
}

function submitInput(e) {
    let input = $("#input").val();
    let [message, command, element] = getMessageAndElement(input);
    
    // Blacken element
    element.removeClass("not-visited");
    element.addClass("visited");

    // Rewrite its text
    element.text(message);

    // Find next un-visited
    while (true) {
        element = element.next();
        console.log("Next:", element);
        if (element.length == 0 || element.hasClass("not-visited")) {
            break;
        }
    }

    // Get text from its prefill attribute and put it in the input box
    if (element) {
        let prefill_with = element.attr("prefill");
        $("#input")
            .val(prefill_with)
            .focus()
            .select();
        
        // Refresh preview
        checkInput();
    }
}

console.log("Loaded");
window.onload = setupStuff;
