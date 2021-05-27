


clc;
clear all;
close all;
msg = input('Enter the text to compress and encode : ','s');


enc_dec = input('\nWelcome to the Steganography Program \nEnter 1 for Encoding \nEnter 2 for Decoding \nEnter 3 for just displaying the LZW dictionary created:\n\n');

if enc_dec == 1
    %% STEP A: ENCODING VERSION
    %% STEP 2A: Select "Canvas Image" and "Message File".
    % First Get "Canvas" Image.
    [FileName,PathName] = uigetfile({'*.jpg';'*.png';'*.gif';'*.bmp'},'Select "Canvas Image" to Hide Message.');
    img = imread( strcat(PathName,FileName) );
    
    
    %% STEP 3A: Prompt User for Encryption Key
    enc_key = input('Please Enter an Encryption Key Between 0 - 255:\n');
    if enc_key < 0 || enc_key > 255
        error('Invalid Key Selection');
    end
    
    enc_key = uint8(enc_key);
    
    %% STEP 4A: Perform sequential encryption

    output = stegancoder(img,msg,enc_key);

    
    %% STEP 5A: Write Canvas Image to .BMP File
    % BMP, or bitmap format, was chosen because it DOES NOT use
    %   compression. JPEG compression destroys the message.
    secfn = input('Enter File Name for Image + Message:\n','s');
    nametest = ischar(secfn);
    if nametest == 1
        imwrite(output,strcat(secfn,'.bmp'));
    else
        error('Invalid File Name');
    end
    
elseif enc_dec == 2
    %% STEP B: DECODING VERSION
    %% STEP 2B: Import "Canvas Image" With Hidden Message.
    [FileName,PathName] = uigetfile('*.bmp','Select "Canvas Image" With Hidden Message.');
    img = imread( strcat(PathName,FileName) );
    
    %% STEP 3B: Prompt User for Encryption Key
    enc_key = input('Please Enter an Encryption Key Between 0 - 255:\n');
    if enc_key < 0 || enc_key > 255
        error('Invalid Key Selection');
    end
    
    enc_key = uint8(enc_key);
    
    %% STEP 4B: Perform sequential decryption

    output = stegandecoder(img,enc_key);

    
    %% STEP 5B: Writing Message to .TXT or .JPG File
    secfn = input('Enter File Name for Image + Message:\n','s');
    nametest = ischar(secfn);
    if nametest == 1
        msgtest = ischar(output);
        if msgtest == 1
            % TEXT Message CASE
            fid = fopen(strcat(secfn,'.txt'),'w');
            fwrite(fid,output,'char');
            fclose(fid);
        else
            % IMAGE Message CASE
            imwrite(output,strcat(secfn,'.bmp'));
        end
    else
        error('Invalid File Name');
    end
    
elseif enc_dec == 3
    
    str = msg;
    disp('The dictionary created is');
    % pack it
    [packed,table]=norm2lzw(uint8(str));

    % unpack it
    [unpacked,table]=lzw2norm(packed);

    % transfor it back to char array
    unpacked = char(unpacked);

    % test
    isOK = strcmp(str,unpacked);

    % show new table elements
    strvcat(table{257:end})
    
else
    error('Invalid Selection');
end






