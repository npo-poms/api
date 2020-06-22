package nl.vpro.poms.followchanges;

import lombok.extern.slf4j.Slf4j;
import nl.vpro.api.client.frontend.NpoApiClients;
import nl.vpro.api.client.utils.NpoApiMediaUtil;
import nl.vpro.domain.api.Deletes;
import nl.vpro.domain.api.MediaChange;
import nl.vpro.domain.api.Order;
import nl.vpro.domain.api.Tail;
import nl.vpro.util.CountedIterator;
import nl.vpro.util.Env;
import nl.vpro.util.TimeUtils;
import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.ITypeConverter;
import picocli.CommandLine.Option;

import java.io.FileDescriptor;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.time.Instant;
import java.util.concurrent.Callable;

import static java.nio.charset.StandardCharsets.UTF_8;

/**
 * @author Michiel Meeuwissen
 */
@Slf4j
@Command(name = "followchange", mixinStandardHelpOptions = true, version = "1.0",
         description = "Follows the media changes feed of the NPO API")
public class Main implements Callable<Integer> {


    @Option(names = {"-e", "--env"}, converter = EnvConvert.class)
    private Env env = Env.PROD;

    @Option(names = {"-p", "--profile"})
    private String profile;

    @Option(names = {"-s", "--since"}, converter = InstantConvert.class)
    private Instant since = Instant.now();

    @Override
    public Integer call() throws Exception {
         changes();
         return 0;
    }

    private void changes() throws InterruptedException {
        NpoApiClients clients = NpoApiClients
            .configured(env)
            .build();

        NpoApiMediaUtil mediaUtil = NpoApiMediaUtil.builder()
            .clients(clients)
            .build();
        Instant start = since;
        String mid = null;
        int call = 0;
        while(true) {

            try (CountedIterator<MediaChange> changes = mediaUtil.changes(profile, false, start, mid, Order.ASC, null, Deletes.ID_ONLY, Tail.ALWAYS)) {
                while (changes.hasNext()) {
                    MediaChange change = changes.next();
                    log.info(call + ":" + change);
                    start = change.getPublishDate();
                    mid = change.getMid();
                }
            } catch (Exception e) {
                log.info(e.getMessage());
            }
            call++;
            Thread.sleep(1000L);
        }
    }



    public static void main(String[] argv) throws InterruptedException {
        // output utf-8 always, why would you want it differently.
        System.setOut(new PrintStream(new FileOutputStream(FileDescriptor.out), true, UTF_8));
        System.exit(new CommandLine(new Main()).execute(argv));


    }

    public static class EnvConvert implements ITypeConverter<Env> {
        @Override
        public Env convert(String value) {
            return Env.valueOf(value.toUpperCase());
        }
    }
    public static class InstantConvert implements ITypeConverter<Instant> {
        @Override
        public Instant convert(String value) {
            return TimeUtils.parse(value).orElse(Instant.now());
        }
    }
}
