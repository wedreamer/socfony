const characters = [];
for (let i = 0; i < 10; ++i) {
    characters.push(String.fromCharCode(48 + i));
}

/**
 * 生成 [min, max] 区间范围内的随机整数
 * 
 * @param {number} min 
 * @param {number} max 
 * @return {number}
 */
function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1) + min);
}
/**
 * 生成随机字符串
 * 
 * @param {number} length 
 * @return {string}
 */
function randomStr(length = 6) {
    const max = characters.length - 1;
    let str = '';
    for (let i = 0; i < length; ++i) {
        str = str + characters[randomInt(0, max)];
    }
    return str;
}

module.exports = {
    randomInt,
    randomStr
};
