function bilimsel_hesap_makinesi_gui()
    f = figure('Name', 'Bilimsel Hesap Makinesi', 'NumberTitle', 'off', ...
               'Position', [500 300 360 400], 'MenuBar', 'none', 'Resize', 'off');
    exprBox = uicontrol('Style', 'edit', 'Parent', f, ...
        'Position', [20 350 320 35], 'FontSize', 14, ...
        'HorizontalAlignment','right', 'String', '', ...
        'KeyPressFcn', @exprBoxKeyPress);
    % Düğme tanımlamaları
    buttons = { ...
      '7', '8', '9', '/', 'sin', 'cos'; ...
      '4', '5', '6', '*', 'tan', 'log'; ...
      '1', '2', '3', '-', 'sqrt', 'x^y'; ...
      '0', '.', '=', '+', '(', ')'; ...
      'pi', 'e', '!', 'C', '', '' ...
    };
    btn_w = 50; btn_h = 40; gap = 10;
    start_x = 20; start_y = 290;
    for i = 1:size(buttons,1)
        for j = 1:size(buttons,2)
            label = buttons{i,j};
            if isempty(label), continue; end
            xpos = start_x + (j-1)*(btn_w+gap);
            ypos = start_y - (i-1)*(btn_h+gap);
            uicontrol('Style', 'pushbutton', 'String', label, ...
                'Position', [xpos ypos btn_w btn_h], 'FontSize', 12, ...
                'Callback', @(src,~)button_callback(exprBox, get(src, 'String')));
        end
    end
end

function exprBoxKeyPress(src, event)
    % Enter veya Return tuşuna basılırsa hesapla
    if strcmp(event.Key, 'return') || strcmp(event.Key, 'enter')
        expr = get(src, 'String');
        try
            str = expr;
            str = strrep(str, 'pi', 'pi');
            str = strrep(str, 'e', 'exp(1)');
            str = regexprep(str, '(\d+)!', 'fakt($1)');
            str = strrep(str, 'sqrt', 'sqrt');
            str = strrep(str, 'x^y', '^');
            str = strrep(str, 'sin', 'sin');
            str = strrep(str, 'cos', 'cos');
            str = strrep(str, 'tan', 'tan');
            str = strrep(str, 'log', 'log10');
            value = eval(str);
            set(src, 'String', num2str(value));
        catch
            set(src, 'String', 'Hata!');
        end
    end
end

function button_callback(exprBox, label)
    persistent expr
    if isempty(expr)
        expr = '';
    end

    switch label
        case {'0','1','2','3','4','5','6','7','8','9','+','-','*','/','(',')','.'}
            expr = [expr label];
            set(exprBox, 'String', expr);
        case '='
            try
                str = expr;
                str = strrep(str, 'pi', 'pi');
                str = strrep(str, 'e', 'exp(1)');
                str = regexprep(str, '(\d+)!', 'fakt($1)');
                str = strrep(str, 'sqrt', 'sqrt');
                str = strrep(str, 'x^y', '^');
                str = strrep(str, 'sin', 'sin');
                str = strrep(str, 'cos', 'cos');
                str = strrep(str, 'tan', 'tan');
                str = strrep(str, 'log', 'log10');
                value = eval(str);
                set(exprBox, 'String', num2str(value));
                expr = num2str(value);
            catch
                set(exprBox, 'String', 'Hata!');
                expr = '';
            end
        case 'C'
            expr = '';
            set(exprBox, 'String', '');
        case 'sin'
            expr = [expr 'sin('];
            set(exprBox, 'String', expr);
        case 'cos'
            expr = [expr 'cos('];
            set(exprBox, 'String', expr);
        case 'tan'
            expr = [expr 'tan('];
            set(exprBox, 'String', expr);
        case 'log'
            expr = [expr 'log('];
            set(exprBox, 'String', expr);
        case 'sqrt'
            expr = [expr 'sqrt('];
            set(exprBox, 'String', expr);
        case 'x^y'
            expr = [expr '^'];
            set(exprBox, 'String', expr);
        case '!'
            expr = [expr '!'];
            set(exprBox, 'String', expr);
        case 'pi'
            expr = [expr 'pi'];
            set(exprBox, 'String', expr);
        case 'e'
            expr = [expr 'e'];
            set(exprBox, 'String', expr);
    end
end

function y = fakt(n)
    y = prod(1:n);
end