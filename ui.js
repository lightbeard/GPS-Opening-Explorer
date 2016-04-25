

// init file table
var files = localStorage.getItem('files');

if(files) {
    files = JSON.parse(files);
    
    for(var filename in files) {
        
        var id = filename.replace(/\.|:/g,'_');
        
        $('#files').append('<tr id="' + id + '"><td><a href="#" onclick="window.fileclick(\'' + filename + '\');">' + filename + '</a></td><td><button onclick="window.deletefile(\'' + filename + '\');" class="sm-button">Delete</button></td></tr>');
    }
    $('#files').css('display', 'block');
}


// functions

function alertWithoutTitle(text) {
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", 'data:text/plain,');
    document.documentElement.appendChild(iframe);
    window.frames[0].window.alert(text);
    iframe.parentNode.removeChild(iframe);
};

function backendCall(url) {
    var iframe = document.createElement("IFRAME");
    iframe.setAttribute("src", 'js-frame://' + url);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
};

function newfile(filename, path) {
    
    var id = filename.replace(/\.|:/g,'_');
    
    $('#files').css('display','block').append('<tr id="' + id + '"><td><a href="#" onclick="window.fileclick(\'' + filename + '\');">' + filename + '</a></td><td><button onclick="window.deletefile(\'' + filename + '\');" class="sm-button">Delete</button></td></tr>');
    
    var files = localStorage.getItem('files');
    
    files = (files) ? JSON.parse(files) : {};
    
    files[filename] = path;
    
    localStorage.setItem('files', JSON.stringify(files));
};

function fileclick(filename) {
    var filepath = JSON.parse(localStorage.getItem('files'))[filename];
    backendCall('mailfile/' + encodeURIComponent(filepath));
};

function deletefile(filename) {
    
    var id = filename.replace(/\.|:/g,'_');

    var $button = $('tr#'+id+' button');
    
    if( $button.length === 1 ) {
        
        // step1
        $button.replaceWith('<img class="del-img" onclick="window.deletefile(\'' + filename + '\')" src="del.png">');
        
    } else {
        
        // step 2
        var files = JSON.parse(localStorage.getItem('files'));
        var filepath = files[filename];
        
        delete files[filename];
        
        localStorage.setItem('files', JSON.stringify(files));
        
        backendCall('delete/' + encodeURIComponent(filepath));
        
        $('tr#'+id).remove();
    }
};

function updateTimer() {
    if(window.timer) {
        var start = window.timer;
        var now = Date.now();
        var diff = now - start;
        
        var min = Math.floor((diff / 1000) / 60);
        min = (min < 10) ? '0' + min.toString() : min.toString();
        
        var sec = diff / 1000;
        while(sec > 60) sec = sec % 60;
        
        sec = Math.floor(sec);
        sec = (sec < 10) ? '0' + sec.toString() : sec.toString();
        
        $('#timer').html(min + ':' + sec);
        
        setTimeout(updateTimer, 1000);
    }
};

$('#record').click(function() {
                   
   var fileId = $('#file-id').val();
                   
    if( !/^\d{5,7}$/.test(fileId) ) {
        
        alertWithoutTitle('Filename ID is required and must be a number between 5-7 digits long');
                   
   } else {
                   
        $('#record').prop('disabled', true).addClass('circle');
        backendCall('record/' + fileId);
        $('#circle').prop('src', 'rcir.jpg');
                       
        window.timer = Date.now();
        updateTimer();
                       
       var loopImage = function(){
       
           $('#circle').fadeIn(1500, function(){
                if(window.timer) $('#circle').fadeOut(100, loopImage);
            });
       }
       loopImage();
                   
   }
});

$('#stop').click(function() {
    window.timer = false;
    $('#timer').html('00:00');
    backendCall('stop');
    $('#record').prop('disabled', false);
    $('#circle').prop('src', 'gcir.jpg');
});