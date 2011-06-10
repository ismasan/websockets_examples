// NOTES
// The File api at http://www.w3.org/TR/FileAPI/ 

var clearAll = function(){
  var reader = new LocalReader();
  reader.forEach(function(key, value){
    localStorage.removeItem(key);
  })
  
  $('#images').html('');
}

var LocalReader = (function () {
  
  function LocalReader () {
    this.keys = [];
  }
  
  LocalReader.prototype = {
    forEach: function (iterator) {
      console.log("reading local storage")
      for(i= localStorage.length - 1; i >= 0; i--){
        var key = localStorage.key(i);
        var item = localStorage.getItem(key);
        iterator(key, item)
      }
    }
  }
  
  return LocalReader;
})();

function addImage($container, image_data) {
  var image = new Image();
  image.onload = function () {
    var $self = $(this);
    $(this).attr('width', 200).appendTo($container);          
  }
  image.src = image_data;
}

document.addEventListener("load", function(evt){
  
  $('#clear').click(clearAll);
  
  var storageReader = new LocalReader();
  socket = new WebSocket("ws://eyas.local:8080/foo");
  
  socketStatus(socket);
  
  storageReader.forEach(function (key, image_data) {
    console.log(key)
    addImage($('#images'), image_data)
  })
  
  socket.onmessage = function(evt){
    var image = JSON.parse(evt.data)
    addImage($('#images'), image.data)
    localStorage.setItem(image.name, image.data)
  };
  
  
  //
  // Need to turn off default dragover behaviour to get
  // filedropping to work
  //
  var stopPropagation = function(evt){
    evt.stopPropagation();
    evt.preventDefault();
  }
  
  document.addEventListener('dragenter', stopPropagation, false);
  document.addEventListener('dragexit', stopPropagation, false);
  document.addEventListener('dragover', stopPropagation, false); 
  document.addEventListener('drop', function (evt) {
    var fileReader = new FileReader();
    fileReader.onloadend = function(evt){
      if (!evt.target.error) {
        image = {
          name: file.fileName,
          data: evt.target.result
        }
        socket.send(JSON.stringify(image))
      }
    };
    
    fileReader.onerror = function(evt){
      console.log("Error", evt)
    }
    
    var file = evt.dataTransfer.files[0];
    fileReader.readAsDataURL(file);
    
    evt.stopPropagation();
    evt.preventDefault();
  }, false)
  
 
}, true)