var browserify = require("browserify");
var buffer = require("vinyl-buffer");
var clean = require("gulp-clean-css");
var concat = require("gulp-concat");
var gulp = require("gulp");
var gulpif = require("gulp-if");
var gutil = require("gulp-util");
var reactify = require("coffee-reactify")
var source = require("vinyl-source-stream");
var uglify = require("gulp-uglify");
var watchify = require("watchify");

// Bower components
var Bower = {
    css: [
        "bower_components/bootstrap/dist/css/bootstrap.css",
        "bower_components/bootswatch/paper/bootstrap.css",
        "bower_components/font-awesome/css/font-awesome.css"
    ],
    js: [
        "bower_components/jquery/dist/jquery.js",
        "bower_components/bootstrap/dist/js/bootstrap.js",
        "bower_components/moment/moment.js"
    ],
    fonts: [
        "bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.eot",
        "bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.svg",
        "bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.ttf",
        "bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.woff",
        "bower_components/bootstrap/dist/fonts/glyphicons-halflings-regular.woff2",
        "bower_components/font-awesome/fonts/fontawesome-webfont.eot",
        "bower_components/font-awesome/fonts/fontawesome-webfont.svg",
        "bower_components/font-awesome/fonts/fontawesome-webfont.ttf",
        "bower_components/font-awesome/fonts/fontawesome-webfont.woff",
        "bower_components/font-awesome/fonts/fontawesome-webfont.woff2",
        "bower_components/font-awesome/fonts/FontAwesome.otf"
    ]
}

// Creates a browserify stream
function browserifyStream(options)
{
    var stream = browserify("index.cjsx", options)
    stream.transform(reactify);
    return stream;
}

// Creates a browserify stream wrapped by watchify
function watchifyStream(options, bundle)
{
    var options = Object.assign({}, watchify.args, options);
    var stream = watchify(browserifyStream(options));
    stream.on("update", bundle);
    stream.on("log", gutil.log);
    return stream;
}

// Client javascript
function client(watch)
{
    return function()
    {
        var stream;
        var options = {extensions: [".cjsx", ".coffee"]};

        if(watch)
        {
            stream = watchifyStream(options, bundle);
        }
        else
        {
            stream = browserifyStream(options);
        }

        if(gutil.env.production)
        {
            process.env.NODE_ENV = "production";
        }

        return bundle();

        function bundle()
        {
            return stream.bundle()
                .on("error", function(e)
                {
                    gutil.log(e.toString());
                })
                .pipe(source("bundle.js"))
                .pipe(buffer())
                .pipe(gulpif(gutil.env.production, uglify()))
                .pipe(gulp.dest("./public/js/"));
        }
    }
}

// Third party javascript
function js()
{
    return gulp.src(Bower.js)
        .pipe(concat("lib.js"))
        .pipe(gulpif(gutil.env.production, clean({compatibility: "ie8", processImports: false})))
        .pipe(gulp.dest("public/js"));
}

// Third party css
function css()
{
    return gulp.src(Bower.css)
        .pipe(concat("lib.css"))
        .pipe(gulpif(gutil.env.production, uglify()))
        .pipe(gulp.dest("public/css"));
}

// Third party fonts
function fonts()
{
    return gulp.src(Bower.fonts)
        .pipe(gulp.dest("public/fonts"));
}

// Tasks
gulp.task("client", client(false));
gulp.task("clientWatch", client(true));
gulp.task("js", js);
gulp.task("css", css);
gulp.task("fonts", fonts);

// Combined tasks
gulp.task("default", ["client", "libs", "styles", "fonts"]);
gulp.task("watch", ["clientWatch", "js", "css", "fonts"])
