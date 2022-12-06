miniBatchSize = 16;
numEpochs = 30;
numObservations = numel(original.Labels);
numIterationsPerEpoch = floor(numObservations./miniBatchSize);
executionEnvironment = "gpu";

averageGrad = [];
averageSqGrad = [];
iteration = 1; % initialize iteration

plots = "training-progress";
if plots == "training-progress"
    f1=figure;
    lineLossTrain = animatedline('Color','r');
    xlabel("Total Iterations")
    ylabel("Loss");lineLossValid = animatedline('Color','b');
    xlabel("Total Iterations");ylabel("LossValid")
end

YTrain = original.Labels;
numClasses = numel(classes); 

for epoch = 1:numEpochs
    % Shuffle data.
    idx = randperm(numel(YTrain));
    original = original(:,:,:,idx);
    fuzzy = fuzzy(:,:,:,idx);
    YTrain=YTrain(idx);
    
    for i = 1:numIterationsPerEpoch
        
        % Read mini-batch of data and convert the labels to dummy
        % variables.
        idx = (i-1)*miniBatchSize+1:i*miniBatchSize;
        XUpper = original(:,:,:,idx);
        XBottom = fuzzy(:,:,:,idx);
        
        Y = zeros(numClasses, miniBatchSize, 'single');
        for c = 1:numClasses
            Y(c,YTrain(idx)==classes(c)) = 1;
        end
        
        % Convert mini-batch of data to a dlarray.
        original_1 = dlarray(single(XUpper),'SSCB');
        fuzzy_1 = dlarray(single(XBottom),'SSCB');
        
        % If training on a GPU, then convert data to a gpuArray.
        if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
            original_1 = gpuArray(original_1);
            fuzzy_1 = gpuArray(fuzzy_1);
        end
        
        % Update the network parameters using the Adam optimizer.
        [lgraph_1,averageGrad,averageSqGrad] = adamupdate(lgraph_1,grad,averageGrad,averageSqGrad,iteration,0.0005);
        
        % Display the training progress.
        if plots == "training-progress"
            addpoints(lineLossTrain,iteration,double(gather(extractdata(loss))))
            title("Loss During Training: Epoch - " + epoch + "; Iteration - " + i)
            addpoints(lineLossValid,iteration,double(gather(extractdata(lossValid))))
            title("Loss During Validation: Epoch - " + epoch + "; Iteration - " + i)
            drawnow
        end
        
        % Increment the iteration counter.
        iteration = iteration + 1;
    end
end