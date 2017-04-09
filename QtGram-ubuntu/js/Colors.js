.pragma library

var AVATARS = [
    "#8179d7",
    "#f2749a",
    "#7ec455",
    "#f3c34a",
    "#5b9dd8",
    "#62b8cd",
    "#ed8b4a",
    "#d95848"
]

function getColor(userId) {
    print("userid", userId)
//    if (!userId) userId = 0;
    return AVATARS[userId % 8];
}

