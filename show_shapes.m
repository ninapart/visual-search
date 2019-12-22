function new_bounds = show_shapes(shape,color,number,bounds)
%SHOW_SHAPES - add shapes on random spots on the figure
%   show_shapes(shape,color,number,bounds) - returns the totals bounds of
%   the added shapes on the figure.

for j = 1:number
    x = rand; y = rand;
    % Verify the figure doesn't overlap
    while inpolygon(x,y,bounds(1,:),bounds(2,:))
        x = rand; y = rand;
    end
    t = text(x,y,shape,'Color',color);
    % Add the new shape's bounds + the surrounding problematic area
    % (if the next shape starts there, it'll overlap)
    left=x-t.Extent(3)+0.005; down=t.Extent(2)+0.005; 
    up=down+t.Extent(4)-0.01; right=x+t.Extent(3)-0.005; 
    
    % Make sure we're not exceeding the borders
    if left<0 left=0;, end
    if up>1 up=1;, end
    if down<0 down=0;, end
    if right>1 right=1;, end
    
    % Add the new bounds (this is a matrix of all the areas
    % overlapping the figures that are on the screen)
    bounds = [bounds(1,:) [left right right left left NaN]; ...
        bounds(2,:) [up up down down up NaN]];
end

new_bounds = bounds;

end

